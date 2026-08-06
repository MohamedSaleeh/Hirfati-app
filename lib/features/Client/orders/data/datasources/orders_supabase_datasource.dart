import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/models/order.dart';
import '../../domain/models/order_model.dart';

class OrdersSupabaseDatasource {
  final SupabaseClient _supabaseClient;
  OrdersSupabaseDatasource(this._supabaseClient);

  // ============================================================
  // Get User ID Helper
  // ============================================================
  String _getUserId() {
    final userId = _supabaseClient.auth.currentUser?.id;
    print('🔐 _getUserId() called, userId: $userId');
    if (userId == null) {
      print('❌ User is not authenticated!');
      throw Exception('User is not authenticated');
    }
    print('✅ User authenticated: $userId');
    return userId;
  }

  // ============================================================
  // Get Client Orders
  // ============================================================
  Future<List<OrderModel>> getClientOrders(OrderStatus status) async {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📦 getClientOrders() called');
    print('   Status: ${status.name}');

    try {
      final userId = _getUserId();
      final String statusString = _orderStatusToString(status);

      print('📋 Query params:');
      print('   - userId: $userId');
      print('   - status: $statusString');
      print('   - is_active: true');

      final response = await _supabaseClient
          .from('orders')
          .select('''
            id,
            client_id,
            worker_id,
            status,
            payment_status,
            payment_method,
            payment_transaction_id,
            paid_at,
            scheduled_at,
            price,
            description,
            address,
            latitude,
            longitude,
            created_at,
            title,
            workers (
              rating_average,
              profiles!workers_user_id_fkey (
                full_name,
                avatar_url
              )
            ),
            services (
              title
            )
          ''')
          .eq('client_id', userId)
          .eq('status', statusString)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      print('📊 Response received:');
      print('   - Type: ${response.runtimeType}');

      if (response is List) {
        print('   - Number of orders: ${response.length}');
        if (response.isEmpty) {
          print(
            '⚠️ No orders found for user: $userId with status: $statusString',
          );
        } else {
          for (var i = 0; i < response.length; i++) {
            final order = response[i];
            print(
              '   - Order ${i + 1}: id=${order['id']}, status=${order['status']}, price=${order['price']}',
            );
          }
        }
      }

      final result = (response as List<dynamic>)
          .map((json) => _mapToOrderModel(json))
          .toList();
      print('✅ Successfully mapped ${result.length} orders');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      return result;
    } catch (e, stack) {
      print('❌ ERROR in getClientOrders():');
      print('   - Error: $e');
      print('   - Stack trace: $stack');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      rethrow;
    }
  }

  // ============================================================
  // Cancel Order
  // ============================================================
  Future<void> cancelOrder(String orderId) async {
    print('🗑️ cancelOrder() called for orderId: $orderId');

    try {
      final userId = _getUserId();
      print('   - UserId: $userId');

      await _supabaseClient
          .from('orders')
          .update({
            'status': 'cancelled',
            'cancelled_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId)
          .eq('client_id', userId);

      print('✅ Order cancelled successfully: $orderId');
    } catch (e) {
      print('❌ Error cancelling order: $e');
      rethrow;
    }
  }

  // ============================================================
  // Reorder - Create new order from existing one
  // ============================================================
  Future<String> reorder(String oldOrderId) async {
    print('🔄 reorder() called for oldOrderId: $oldOrderId');

    try {
      final userId = _getUserId();
      print('   - UserId: $userId');

      // تعطيل الطلب القديم
      print('   - Deactivating old order...');
      await _supabaseClient
          .from('orders')
          .update({'is_active': false})
          .eq('id', oldOrderId)
          .eq('client_id', userId);

      // جلب بيانات الطلب القديم
      print('   - Fetching old order data...');
      final oldOrder = await _supabaseClient
          .from('orders')
          .select('''
            worker_id,
            service_id,
            description,
            address,
            latitude,
            longitude,
            preferred_time_slot,
            access_instructions,
            price,
            title
          ''')
          .eq('id', oldOrderId)
          .eq('client_id', userId)
          .single();

      print(
        '   - Old order data: worker_id=${oldOrder['worker_id']}, price=${oldOrder['price']}',
      );

      // إنشاء طلب جديد
      print('   - Creating new order...');
      final newOrder = await _supabaseClient
          .from('orders')
          .insert({
            'client_id': userId,
            'worker_id': oldOrder['worker_id'],
            'service_id': oldOrder['service_id'],
            'description': oldOrder['description'],
            'address': oldOrder['address'],
            'latitude': oldOrder['latitude'],
            'longitude': oldOrder['longitude'],
            'preferred_time_slot': oldOrder['preferred_time_slot'],
            'access_instructions': oldOrder['access_instructions'],
            'price': oldOrder['price'],
            'title': oldOrder['title'],
            'status': 'pending',
            'payment_status': 'pending',
            'created_by': 'client',
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      print('✅ New order created with ID: ${newOrder['id']}');
      return newOrder['id'];
    } catch (e) {
      print('❌ Error reordering: $e');
      rethrow;
    }
  }

  // ============================================================
  // Update Payment Status
  // ============================================================
  Future<void> updatePaymentStatus(
    String orderId,
    PaymentStatus status, {
    String? paymentMethod,
    String? transactionId,
  }) async {
    if (status == PaymentStatus.paid) {
      throw UnsupportedError(
        'Paid order fields are settled only by settle_order_payment',
      );
    }
    print('💰 updatePaymentStatus() called:');
    print('   - orderId: $orderId');
    print('   - status: ${status.name}');
    print('   - paymentMethod: $paymentMethod');
    print('   - transactionId: $transactionId');

    try {
      final userId = _getUserId();
      print('   - UserId: $userId');

      final updateData = {'payment_status': _paymentStatusToString(status)};

      print('   - Update data: $updateData');

      await _supabaseClient
          .from('orders')
          .update(updateData)
          .eq('id', orderId)
          .eq('client_id', userId);

      print('✅ Payment status updated for order: $orderId → ${status.name}');
    } catch (e) {
      print('❌ Error updating payment status: $e');
      rethrow;
    }
  }

  // ============================================================
  // Get Order by ID
  // ============================================================
  Future<Order?> getOrderById(String orderId) async {
    print('🔍 getOrderById() called for orderId: $orderId');

    try {
      final userId = _getUserId();
      print('   - UserId: $userId');

      final response = await _supabaseClient
          .from('orders')
          .select('''
            id,
            client_id,
            worker_id,
            status,
            payment_status,
            payment_method,
            payment_transaction_id,
            paid_at,
            scheduled_at,
            price,
            description,
            address,
            latitude,
            longitude,
            created_at,
            title,
            workers (
              rating_average,
              profiles!workers_user_id_fkey (
                full_name,
                avatar_url
              )
            ),
            services (
              title
            )
          ''')
          .eq('id', orderId)
          .eq('client_id', userId)
          .maybeSingle();

      if (response == null) {
        print('⚠️ Order not found: $orderId');
        return null;
      }

      print(
        '✅ Order found: id=${response['id']}, status=${response['status']}',
      );
      return _mapToOrder(response);
    } catch (e) {
      print('❌ Error getting order: $e');
      return null;
    }
  }

  // ============================================================
  // Private Mapping Methods
  // ============================================================

  OrderModel _mapToOrderModel(Map<String, dynamic> json) {
    print('🔄 _mapToOrderModel() called');
    final order = _mapToOrder(json);
    return OrderModel(order);
  }

  Order _mapToOrder(Map<String, dynamic> json) {
    print('🔄 _mapToOrder() called');

    try {
      final map = Map<String, dynamic>.from(json);
      final worker = map['workers'] as Map<String, dynamic>? ?? {};
      final profile = worker['profiles'] as Map<String, dynamic>? ?? {};
      final service = map['services'] as Map<String, dynamic>? ?? {};

      // استخدام title من جدول orders إذا وجد، وإلا من services
      final serviceTitle =
          map['title']?.toString() ??
          service['title']?.toString() ??
          'Unknown Service';

      print('   - Order ID: ${map['id']}');
      print('   - Worker: ${profile['full_name']}');
      print('   - Service: $serviceTitle');
      print('   - Price: ${map['price']}');
      print('   - Status: ${map['status']}');
      print('   - Payment Status: ${map['payment_status']}');

      return Order(
        id: map['id'].toString(),
        clientId: map['client_id'] as String,
        clientName: '',
        clientAvatarUrl: null,
        workerId: map['worker_id'] as String,
        workerName: profile['full_name']?.toString() ?? 'Unknown Worker',
        workerAvatarUrl: profile['avatar_url'] as String?,
        serviceId: map['service_id'] as String?,
        serviceTitle: serviceTitle,
        price: (map['price'] as num?)?.toDouble() ?? 0.0,
        status: _parseOrderStatus(map['status'] as String? ?? 'pending'),
        paymentStatus: _parsePaymentStatus(
          map['payment_status'] as String? ?? 'pending',
        ),
        requestType: OrderRequestType.scheduled, // سيتم تحديثه حسب الحاجة
        address: map['address']?.toString() ?? '',
        latitude: (map['latitude'] as num?)?.toDouble(),
        longitude: (map['longitude'] as num?)?.toDouble(),
        description: map['description']?.toString(),
        scheduledAt: map['scheduled_at'] != null
            ? DateTime.parse(map['scheduled_at'] as String)
            : null,
        startedAt: null, // غير موجود في قاعدة البيانات
        completedAt: null, // غير موجود في قاعدة البيانات
        paidAt: map['paid_at'] != null
            ? DateTime.parse(map['paid_at'] as String)
            : null,
        paymentMethod: map['payment_method'] as String?,
        paymentTransactionId: map['payment_transaction_id'] as String?,
        distance: 0.0,
        rating: (worker['rating_average'] as num?)?.toDouble() ?? 0.0,
        createdAt: DateTime.parse(map['created_at'] as String),
      );
    } catch (e, stack) {
      print('❌ Error in _mapToOrder():');
      print('   - Error: $e');
      print('   - JSON: $json');
      print('   - Stack: $stack');
      rethrow;
    }
  }

  // ============================================================
  // Helper Methods for Status Conversion
  // ============================================================

  String _orderStatusToString(OrderStatus status) {
    final statusString = status.name;
    print('📝 Converting OrderStatus: $statusString');
    switch (status) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.accepted:
        return 'accepted';
      case OrderStatus.in_progress:
        return 'in_progress';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.rejected:
        return 'rejected';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  OrderStatus _parseOrderStatus(String status) {
    print('📝 Parsing OrderStatus from: $status');
    switch (status) {
      case 'accepted':
        return OrderStatus.accepted;
      case 'in_progress':
        return OrderStatus.in_progress;
      case 'completed':
        return OrderStatus.completed;
      case 'rejected':
        return OrderStatus.rejected;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  String _paymentStatusToString(PaymentStatus status) {
    print('📝 Converting PaymentStatus: ${status.name}');
    switch (status) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.paid:
        return 'paid';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.refunded:
        return 'refunded';
    }
  }

  PaymentStatus _parsePaymentStatus(String status) {
    print('📝 Parsing PaymentStatus from: $status');
    switch (status) {
      case 'paid':
        return PaymentStatus.paid;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  Future<void> _updateWorkerBalanceForOrder(String orderId) async {
    /* Disabled: wallet settlement is owned by settle_order_payment.
    print(
      '💰💰💰 _updateWorkerBalanceForOrder CALLED for order: $orderId 💰💰💰',
    );

    try {
      // جلب تفاصيل الطلب باستخدام client العادي
      final order = await _supabaseClient
          .from('orders')
          .select('''
          worker_id,
          price,
          workers!inner (
            user_id
          )
        ''')
          .eq('id', orderId)
          .single();

      final workerId = order['worker_id'] as String;
      final workerUserId = order['workers']['user_id'] as String;
      final amount = (order['price'] as num?)?.toDouble() ?? 0.0;

      if (amount <= 0) {
        print('⚠️ Amount is zero, skipping balance update');
        return;
      }

      print('💰 Updating worker balance:');
      print('   - Worker ID: $workerId');
      print('   - Worker User ID: $workerUserId');
      print('   - Amount: $amount');

      // ✅ استخدام Service Role Client لتجاوز RLS
      // ✅ تحديث رصيد الحرفي في جدول wallets (موحد)
      final existingBalance = await disabledFinancialClient
          .from('disabled_financial_table')
          .select('balance')
          .eq('user_id', workerUserId)
          .maybeSingle();

      if (existingBalance == null) {
        print('📝 No existing wallet, creating new record...');
        await disabledFinancialClient.from('disabled_financial_table').insert({
          'user_id': workerUserId,
          'balance': amount,
          'created_at': DateTime.now().toIso8601String(),
        });
        print('✅ New wallet created: $amount');
      } else {
        final currentBalance =
            (existingBalance['balance'] as num?)?.toDouble() ?? 0;
        final newBalance = currentBalance + amount;

        print('📝 Updating balance: $currentBalance → $newBalance');

        await disabledFinancialClient
            .from('disabled_financial_table')
            .update({
              'balance': newBalance,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('user_id', workerUserId);

        print('✅ Balance updated: $currentBalance → $newBalance');
      }
    } catch (e) {
      print('❌ Error updating worker balance: $e');
    }
    */
  }

  Future<void> _sendPaymentConfirmationNotification(String orderId) async {
    /* Disabled: settlement notifications are emitted by the backend.
    try {
      final order = await _supabaseClient
          .from('orders')
          .select('''
          worker_id,
          client_id,
          price,
          workers (
            user_id,
            profiles (
              full_name
            )
          ),
          profiles!orders_client_id_fkey (
            full_name
          )
        ''')
          .eq('id', orderId)
          .single();

      final workerUserId = order['workers']['user_id'] as String;
      final workerName =
          order['workers']['profiles']['full_name'] as String? ??
          'Unknown Worker';
      final clientName =
          order['profiles']['full_name'] as String? ?? 'Unknown Client';
      final amount = (order['price'] as num?)?.toDouble() ?? 0.0;

      print('📧 Sending payment confirmation to worker: $workerName');

      final supabaseUrl = dotenv.env['SUPABASE_URL']!;
      final removedCredential = disabledConfiguration;

      final response = await http.post(
        Uri.parse('$supabaseUrl/functions/v1/send-notification'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $removedCredential',
        },
        body: jsonEncode({
          'userId': workerUserId,
          'title': 'Payment Received 💰',
          'body': 'You have received $amount \$ from $clientName',
          'type': 'payment',
          'orderId': orderId,
          'saveToDatabase': true,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Payment confirmation sent successfully');
      } else {
        print('❌ Failed to send payment confirmation: ${response.statusCode}');
        print('   Response: ${response.body}');
      }
    } catch (e) {
      print('❌ Error sending payment confirmation: $e');
    }
    */
  }
}
