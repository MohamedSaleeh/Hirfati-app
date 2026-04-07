import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/models/order.dart';
import '../../../../../core/utils/distance_utils.dart';
import '../../domain/models/incoming_order_model.dart' hide OrderRequestType;

class IncomingOrdersSupabaseDatasource {
  final SupabaseClient _client;

  IncomingOrdersSupabaseDatasource(this._client);

  Future<String?> _getWorkerId(String userId) async {
    final worker = await _client
        .from('workers')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();
    return worker?['id'] as String?;
  }

  // ✅ دالة لجلب موقع الحرفي من profiles عبر workers.user_id
  Future<(double? lat, double? lng)?> _getWorkerLocation(
    String workerId,
  ) async {
    try {
      print('🔍 Getting worker location for worker ID: $workerId');

      // جلب worker ثم ربطه بـ profiles
      final worker = await _client
          .from('workers')
          .select('''
            user_id,
            profiles!workers_user_id_fkey (
              latitude,
              longitude
            )
          ''')
          .eq('id', workerId)
          .maybeSingle();

      if (worker == null) {
        print('⚠️ Worker not found');
        return null;
      }

      final profile = worker['profiles'] as Map<String, dynamic>?;
      if (profile != null) {
        final lat = profile['latitude'] as double?;
        final lng = profile['longitude'] as double?;
        if (lat != null && lng != null) {
          print('✅ Worker location: lat=$lat, lng=$lng');
          return (lat, lng);
        }
      }

      print('⚠️ Worker location not found in profiles');
      return null;
    } catch (e) {
      print('❌ Error getting worker location: $e');
      return null;
    }
  }

  Future<List<IncomingOrderModel>> getIncomingOrders(String userId) async {
    final workerId = await _getWorkerId(userId);
    if (workerId == null) return [];

    // جلب موقع الحرفي
    final workerLocation = await _getWorkerLocation(workerId);
    final workerLat = workerLocation?.$1;
    final workerLng = workerLocation?.$2;

    print('📍 Worker location: lat=$workerLat, lng=$workerLng');

    final response = await _client
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
          service_id,
          client_id,
          worker_id,
          status,
          payment_status,
          payment_method,
          payment_transaction_id,
          paid_at,
          services (
            title
          ),
          client_profile:profiles!orders_client_id_fkey (
            full_name,
            avatar_url,
            latitude,
            longitude
          )
        ''')
        .eq('worker_id', workerId)
        .eq('status', 'pending')
        .order('created_at', ascending: false);

    print(
      '✅ Incoming orders query successful, found: ${response.length} orders',
    );

    final result = <IncomingOrderModel>[];

    for (var json in response as List<dynamic>) {
      final map = Map<String, dynamic>.from(json as Map);
      final service = map['services'] as Map<String, dynamic>? ?? {};
      final client = map['client_profile'] as Map<String, dynamic>? ?? {};

      final createdAt = DateTime.parse(map['created_at'] as String);
      final isImmediate =
          createdAt.difference(DateTime.now()).inMinutes.abs() < 30;

      // ✅ حساب المسافة
      double distance = 0.0;
      if (workerLat != null && workerLng != null) {
        // جلب موقع العميل من client_profile
        final clientLat = client['latitude'] as double?;
        final clientLng = client['longitude'] as double?;

        print(
          '📍 Order ${map['id']} - Client location: lat=$clientLat, lng=$clientLng',
        );

        if (clientLat != null && clientLng != null) {
          distance = DistanceUtils.calculateDistance(
            workerLat,
            workerLng,
            clientLat,
            clientLng,
          );
          print(
            '   Distance calculated from client: ${distance.toStringAsFixed(2)} km',
          );
        } else if (map['latitude'] != null && map['longitude'] != null) {
          final orderLat = (map['latitude'] as num).toDouble();
          final orderLng = (map['longitude'] as num).toDouble();
          distance = DistanceUtils.calculateDistance(
            workerLat,
            workerLng,
            orderLat,
            orderLng,
          );
          print(
            '   Distance calculated from order: ${distance.toStringAsFixed(2)} km',
          );
        } else {
          print('   ⚠️ No location found for client or order');
        }
      } else {
        print('   ⚠️ Worker location not available');
      }

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
        paymentTransactionId: map['payment_transaction_id'] as String?,
        distance: distance,
        rating: null,
        createdAt: createdAt,
      );

      result.add(IncomingOrderModel(order));
    }

    return result;
  }

  Future<void> acceptOrder(String orderId) async {
    await _client
        .from('orders')
        .update({
          'status': 'accepted',
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', orderId);
  }

  Future<void> rejectOrder(String orderId) async {
    await _client
        .from('orders')
        .update({
          'status': 'rejected',
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', orderId);
  }

  OrderStatus _parseOrderStatus(String status) {
    switch (status) {
      case 'pending':
        return OrderStatus.pending;
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

  PaymentStatus _parsePaymentStatus(String status) {
    switch (status) {
      case 'pending':
        return PaymentStatus.pending;
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
