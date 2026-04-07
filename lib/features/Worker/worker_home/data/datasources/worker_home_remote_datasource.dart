import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/models/order.dart';
import '../../domain/models/worker_dashboard_data.dart';
import '../../domain/models/worker_order.dart';

abstract class WorkerHomeRemoteDatasource {
  Future<WorkerDashboardData> fetchDashboard();
  Future<List<WorkerOrder>> fetchIncomingOrders();
  Future<List<WorkerOrder>> fetchActiveJobs();
  Future<bool> fetchAvailability();
  Future<void> updateAvailability(bool isAvailable);
  Future<void> updateOrderStatus(String orderId, String status);
}

class WorkerHomeRemoteDatasourceImpl implements WorkerHomeRemoteDatasource {
  final SupabaseClient client;

  WorkerHomeRemoteDatasourceImpl(this.client);

  Future<String?> _getWorkerId() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return null;

    final worker = await client
        .from('workers')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();

    return worker?['id'] as String?;
  }

  @override
  Future<WorkerDashboardData> fetchDashboard() async {
    final workerId = await _getWorkerId();
    if (workerId == null) {
      return WorkerDashboardData(
        totalEarnings: 0,
        totalCompletedJobs: 0,
        totalActiveJobs: 0,
      );
    }

    // ✅ جلب الطلبات المكتملة والمدفوعة فقط
    final completedOrders = await client
        .from('orders')
        .select('price')
        .eq('worker_id', workerId)
        .eq('status', 'completed')
        .eq('payment_status', 'paid'); // ✅ فقط المدفوعة

    final activeOrders = await client
        .from('orders')
        .select('id')
        .eq('worker_id', workerId)
        .inFilter('status', ['accepted', 'in_progress']);

    double earnings = 0;

    if (completedOrders != null && completedOrders.isNotEmpty) {
      for (final order in completedOrders) {
        final price = (order)['price'];
        if (price != null) {
          earnings += (price as num).toDouble();
        }
      }
    }

    final completedCount = (completedOrders as List?)?.length ?? 0;
    final activeCount = (activeOrders as List?)?.length ?? 0;

    return WorkerDashboardData(
      totalEarnings: earnings,
      totalCompletedJobs: completedCount,
      totalActiveJobs: activeCount,
    );
  }

  @override
  Future<List<WorkerOrder>> fetchIncomingOrders() async {
    final workerId = await _getWorkerId();
    if (workerId == null) return [];

    final response = await client
        .from('orders')
        .select('''
        id,
        price,
        description,
        address,
        latitude,
        longitude,
        scheduled_at,
        created_at,
        status,
        payment_status,
        payment_method,
        paid_at,
        service_id,
        client_id,
        worker_id,
        services (
          title
        ),
        client_profile:profiles!orders_client_id_fkey (
          full_name,
          avatar_url
        )
      ''')
        .eq('worker_id', workerId)
        .eq('status', 'pending')
        .order('created_at', ascending: false);

    return (response as List<dynamic>).map((json) {
      final map = Map<String, dynamic>.from(json as Map);
      final service = map['services'] as Map<String, dynamic>? ?? {};
      final client = map['client_profile'] as Map<String, dynamic>? ?? {};

      final createdAt = DateTime.parse(map['created_at'] as String);
      final isImmediate =
          createdAt.difference(DateTime.now()).inMinutes.abs() < 30;

      final order = Order(
        id: map['id'].toString(),
        clientId: map['client_id'] as String,
        clientName: client['full_name']?.toString() ?? 'Unknown Client',
        clientAvatarUrl: client['avatar_url'] as String?,
        workerId: map['worker_id'] as String,
        workerName: '',
        workerAvatarUrl: null,
        serviceId: map['service_id'] as String?,
        serviceTitle: service['title']?.toString() ?? 'Unknown Service',
        price: (map['price'] as num?)?.toDouble() ?? 0.0,
        status: _parseOrderStatus(map['status'] as String? ?? 'pending'),
        paymentStatus: _parsePaymentStatus(
          map['payment_status'] as String? ?? 'pending',
        ),
        requestType: isImmediate
            ? OrderRequestType.immediate
            : OrderRequestType.scheduled,
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
        paymentTransactionId: null,
        distance: 0.0,
        rating: null,
        createdAt: createdAt,
      );

      return WorkerOrder(order);
    }).toList();
  }

  @override
  Future<List<WorkerOrder>> fetchActiveJobs() async {
    final workerId = await _getWorkerId();
    if (workerId == null) return [];

    final response = await client
        .from('orders')
        .select('''
        id,
        price,
        description,
        address,
        latitude,
        longitude,
        scheduled_at,
        created_at,
        status,
        payment_status,
        payment_method,
        paid_at,
        service_id,
        client_id,
        worker_id,
        services (
          title
        ),
        client_profile:profiles!orders_client_id_fkey (
          full_name,
          avatar_url
        )
      ''')
        .eq('worker_id', workerId)
        .inFilter('status', ['accepted', 'in_progress'])
        .order('created_at', ascending: false);

    return (response as List<dynamic>).map((json) {
      final map = Map<String, dynamic>.from(json as Map);
      final service = map['services'] as Map<String, dynamic>? ?? {};
      final client = map['client_profile'] as Map<String, dynamic>? ?? {};

      final createdAt = DateTime.parse(map['created_at'] as String);
      final isImmediate =
          createdAt.difference(DateTime.now()).inMinutes.abs() < 30;

      final order = Order(
        id: map['id'].toString(),
        clientId: map['client_id'] as String,
        clientName: client['full_name']?.toString() ?? 'Unknown Client',
        clientAvatarUrl: client['avatar_url'] as String?,
        workerId: map['worker_id'] as String,
        workerName: '',
        workerAvatarUrl: null,
        serviceId: map['service_id'] as String?,
        serviceTitle: service['title']?.toString() ?? 'Unknown Service',
        price: (map['price'] as num?)?.toDouble() ?? 0.0,
        status: _parseOrderStatus(map['status'] as String? ?? 'pending'),
        paymentStatus: _parsePaymentStatus(
          map['payment_status'] as String? ?? 'pending',
        ),
        requestType: isImmediate
            ? OrderRequestType.immediate
            : OrderRequestType.scheduled,
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
        paymentTransactionId: null,
        distance: 0.0,
        rating: null,
        createdAt: createdAt,
      );

      return WorkerOrder(order);
    }).toList();
  }

  @override
  Future<bool> fetchAvailability() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return false;

    final worker = await client
        .from('workers')
        .select('is_available')
        .eq('user_id', userId)
        .maybeSingle();

    return (worker?['is_available'] == true);
  }

  @override
  Future<void> updateAvailability(bool isAvailable) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    await client
        .from('workers')
        .update({'is_available': isAvailable})
        .eq('user_id', userId);
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    final orderData = await client
        .from('orders')
        .select('''
        id,
        worker_id,
        client_id,
        price,
        service_id,
        payment_status,
        services (
          title
        )
      ''')
        .eq('id', orderId)
        .single();

    final workerId = orderData['worker_id'] as String;
    final clientId = orderData['client_id'] as String;
    final service = orderData['services'] as Map<String, dynamic>?;
    final serviceTitle = service?['title'] as String? ?? 'Service';
    final price = (orderData['price'] as num?)?.toDouble() ?? 0;

    await client.from('orders').update({'status': status}).eq('id', orderId);

    final worker = await client
        .from('workers')
        .select('''
        id,
        user_id,
        profiles!workers_user_id_fkey (
          full_name,
          avatar_url
        )
      ''')
        .eq('id', workerId)
        .single();

    final profile = worker['profiles'] as Map<String, dynamic>?;
    final workerName = profile?['full_name'] as String? ?? 'Craftsman';

    await _sendNotificationToClient(
      clientId: clientId,
      orderId: orderId,
      status: status,
      serviceTitle: serviceTitle,
      workerName: workerName,
      price: price,
    );

    if (status == 'completed') {
      final paymentStatus = orderData['payment_status'] as String? ?? 'pending';
      if (paymentStatus == 'pending') {
        await _sendPaymentRequestNotification(
          clientId,
          orderId,
          price,
          serviceTitle,
          workerName,
        );
      }
    }
  }

  Future<void> _sendPaymentRequestNotification(
    String clientId,
    String orderId,
    double price,
    String serviceTitle,
    String workerName,
  ) async {
    print('🔵 [DEBUG] Sending payment request to client: $clientId');

    final title = 'Payment Required 💰';
    final body =
        'Please pay $price SAR for "$serviceTitle" completed by $workerName.';

    try {
      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final serviceRoleKey = dotenv.env['SUPABASE_SERVICE_ROLE_KEY'];

      final response = await http.post(
        Uri.parse('$supabaseUrl/functions/v1/send-notification'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serviceRoleKey',
        },
        body: jsonEncode({
          'userId': clientId,
          'title': title,
          'body': body,
          'type': 'payment_request',
          'orderId': orderId,
        }),
      );

      print('🔵 [DEBUG] Payment request response: ${response.statusCode}');
    } catch (e) {
      print('❌ Error sending payment request: $e');
    }
  }

  Future<void> _sendNotificationToClient({
    required String clientId,
    required String orderId,
    required String status,
    required String serviceTitle,
    required String workerName,
    required double price,
  }) async {
    print('🔵 [DEBUG] Sending notification to client: $clientId');
    print('🔵 [DEBUG] Status: $status');
    print('🔵 [DEBUG] Service Title: $serviceTitle');

    String title;
    String body;
    String notificationType;

    switch (status) {
      case 'accepted':
        title = 'Order Accepted! ✅';
        body = '$workerName has accepted your request for "$serviceTitle".';
        notificationType = 'order';
        break;
      case 'rejected':
        title = 'Order Declined ❌';
        body = 'Your request for "$serviceTitle" was declined by $workerName.';
        notificationType = 'order';
        break;
      case 'in_progress':
        title = 'Work Started! 🔨';
        body = '$workerName has started working on "$serviceTitle".';
        notificationType = 'order';
        break;
      case 'completed':
        title = 'Job Completed! 🎉';
        body =
            '$workerName has completed "$serviceTitle". Please leave a review!';
        notificationType = 'order';
        break;
      default:
        print('⚠️ Unknown status: $status');
        return;
    }

    print('🔵 [DEBUG] Title: $title');
    print('🔵 [DEBUG] Body: $body');

    try {
      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final serviceRoleKey = dotenv.env['SUPABASE_SERVICE_ROLE_KEY'];

      print('🔵 [DEBUG] Sending HTTP request to edge function...');

      final response = await http.post(
        Uri.parse('$supabaseUrl/functions/v1/send-notification'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serviceRoleKey',
        },
        body: jsonEncode({
          'userId': clientId,
          'title': title,
          'body': body,
          'type': notificationType,
          'orderId': orderId,
        }),
      );

      print('🔵 [DEBUG] Response status: ${response.statusCode}');
      print('🔵 [DEBUG] Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Notification sent to client: $clientId');
      } else {
        print('❌ Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('❌ Error sending notification: $e');
    }
  }

  OrderStatus _parseOrderStatus(String? status) {
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

  PaymentStatus _parsePaymentStatus(String? status) {
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
