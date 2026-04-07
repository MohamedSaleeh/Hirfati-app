import '../../../../../core/models/order.dart';

class IncomingOrderModel {
  final Order _order;

  IncomingOrderModel(this._order);

  String get id => _order.id;
  String get serviceTitle => _order.serviceTitle;
  double get price => _order.price;
  String get clientName => _order.clientName;
  String? get clientAvatarUrl => _order.clientAvatarUrl;
  double get distance => _order.distance ?? 0;
  String get address => _order.address;
  DateTime get createdAt => _order.createdAt;

  OrderRequestType get requestType => _order.requestType;

  DateTime? get scheduledAt => _order.scheduledAt;
  String? get description => _order.description;
  double? get latitude => _order.latitude;
  double? get longitude => _order.longitude;

  PaymentStatus get paymentStatus => _order.paymentStatus;

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

  bool get isPaid => _order.paymentStatus == PaymentStatus.paid;

  factory IncomingOrderModel.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('Use Order model instead');
  }

  Map<String, dynamic> toJson() => _order.toJson();
}
