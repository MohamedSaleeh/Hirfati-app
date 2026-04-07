import '../../../../../core/models/order.dart';

class OrderModel {
  final Order _order;

  OrderModel(this._order);

  String get id => _order.id;
  String get workerId => _order.workerId;
  String get workerName => _order.workerName;
  String get workerAvatar => _order.workerAvatarUrl ?? '';
  String get profession => _order.serviceTitle;
  double get rating => _order.rating ?? 0;
  OrderStatus get status => _order.status;
  DateTime? get scheduledAt => _order.scheduledAt;
  DateTime? get startedAt => _order.startedAt;
  double get price => _order.price;
  String get address => _order.address;
  String? get description => _order.description;

  PaymentStatus get paymentStatus => _order.paymentStatus;
  bool get isPaid => _order.paymentStatus == PaymentStatus.paid;
  DateTime? get paidAt => _order.paidAt;
  String? get paymentMethod => _order.paymentMethod;

  String get paymentStatusDisplay {
    switch (_order.paymentStatus) {
      case PaymentStatus.pending:
        return 'Not Paid';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.failed:
        return 'Payment Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(Order.fromJson(json));
  }

  Map<String, dynamic> toJson() => _order.toJson();
}
