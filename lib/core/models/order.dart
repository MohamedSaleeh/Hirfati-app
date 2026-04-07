import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

enum OrderRequestType { immediate, scheduled }

enum OrderStatus {
  pending,
  accepted,
  in_progress,
  completed,
  rejected,
  cancelled,
}

enum PaymentStatus { pending, paid, failed, refunded }

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required String clientId,
    required String clientName,
    String? clientAvatarUrl,
    required String workerId,
    required String workerName,
    String? workerAvatarUrl,
    String? serviceId,
    required String serviceTitle,
    required double price,
    required OrderStatus status,
    required PaymentStatus paymentStatus,
    required OrderRequestType requestType,
    required String address,
    double? latitude,
    double? longitude,
    String? description,
    DateTime? scheduledAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? paidAt,
    String? paymentMethod,
    String? paymentTransactionId,
    double? distance,
    double? rating,
    required DateTime createdAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
