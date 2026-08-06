import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/models/order.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../domain/models/order_model.dart';

class OrdersSupabaseDatasource {
  final SupabaseClient _supabaseClient;

  OrdersSupabaseDatasource(this._supabaseClient);

  String _getUserId() {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User is not authenticated');
    }
    return userId;
  }

  Future<List<OrderModel>> getClientOrders(OrderStatus status) async {
    final userId = _getUserId();
    final statusString = _orderStatusToString(status);

    final response = await _supabaseClient
        .from('orders')
        .select(_orderSelect)
        .eq('client_id', userId)
        .eq('status', statusString)
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((json) => _mapToOrderModel(json))
        .toList();
  }

  Future<void> cancelOrder(String orderId) async {
    final userId = _getUserId();

    await _supabaseClient
        .from('orders')
        .update({
          'status': 'cancelled',
          'cancelled_at': DateTime.now().toIso8601String(),
        })
        .eq('id', orderId)
        .eq('client_id', userId);
  }

  Future<String> reorder(String oldOrderId) async {
    final userId = _getUserId();

    await _supabaseClient
        .from('orders')
        .update({'is_active': false})
        .eq('id', oldOrderId)
        .eq('client_id', userId);

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
        .select('id')
        .single();

    return newOrder['id'].toString();
  }

  Future<void> updatePaymentStatus(
    String orderId,
    PaymentStatus status, {
    String? paymentMethod,
    String? transactionId,
  }) async {
    if (status == PaymentStatus.paid) {
      throw UnsupportedError(
        'Paid settlements must use the settle_order_payment RPC.',
      );
    }

    final userId = _getUserId();
    final updateData = {
      'payment_status': _paymentStatusToString(status),
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (transactionId != null) 'payment_transaction_id': transactionId,
    };

    await _supabaseClient
        .from('orders')
        .update(updateData)
        .eq('id', orderId)
        .eq('client_id', userId);
  }

  Future<Order?> getOrderById(String orderId) async {
    try {
      final userId = _getUserId();

      final response = await _supabaseClient
          .from('orders')
          .select(_orderSelect)
          .eq('id', orderId)
          .eq('client_id', userId)
          .maybeSingle();

      if (response == null) return null;
      return _mapToOrder(response);
    } catch (error, stackTrace) {
      AppLogger.error(
        error,
        stackTrace: stackTrace,
        message: 'Unable to load order',
      );
      return null;
    }
  }

  OrderModel _mapToOrderModel(Map<String, dynamic> json) {
    return OrderModel(_mapToOrder(json));
  }

  Order _mapToOrder(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);
    final worker = map['workers'] as Map<String, dynamic>? ?? {};
    final profile = worker['profiles'] as Map<String, dynamic>? ?? {};
    final service = map['services'] as Map<String, dynamic>? ?? {};
    final serviceTitle =
        map['title']?.toString() ??
        service['title']?.toString() ??
        'Unknown Service';

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
      requestType: OrderRequestType.scheduled,
      address: map['address']?.toString() ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      description: map['description']?.toString(),
      scheduledAt: map['scheduled_at'] != null
          ? DateTime.parse(map['scheduled_at'] as String)
          : null,
      startedAt: null,
      completedAt: null,
      paidAt: map['paid_at'] != null
          ? DateTime.parse(map['paid_at'] as String)
          : null,
      paymentMethod: map['payment_method'] as String?,
      paymentTransactionId: map['payment_transaction_id'] as String?,
      distance: 0.0,
      rating: (worker['rating_average'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  String _orderStatusToString(OrderStatus status) {
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
}

const _orderSelect = '''
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
  service_id,
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
''';
