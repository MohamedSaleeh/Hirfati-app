import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/models/order.dart';
import '../../../../review/data/providers/review_providers.dart';
import '../../data/providers/orders_repository_provider.dart'; 
import '../../domain/models/order_model.dart';

class OrdersNotifier extends AsyncNotifier<List<OrderModel>> {
  final OrderStatus status;

  OrdersNotifier(this.status);

  @override
  Future<List<OrderModel>> build() async {
    return _fetchOrders(status);
  }

  Future<List<OrderModel>> _fetchOrders(OrderStatus status) async {
    final repository = ref.read(ordersRepositoryProvider);
    return repository.getClientOrders(status);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchOrders(status));
  }
}

final ordersProvider =
    AsyncNotifierProvider.family<OrdersNotifier, List<OrderModel>, OrderStatus>(
      (status) => OrdersNotifier(status),
    );

// Provider لمراقبة حالة التقييم لكل طلب
final orderReviewStatusProvider = FutureProvider.family<bool, String>((
  ref,
  orderId,
) async {
  final repository = ref.watch(reviewRepositoryProvider);
  return await repository.hasReviewed(orderId);
});
