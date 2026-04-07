import '../../../../../core/models/order.dart';

class WorkerOrder {
  final Order _order;
  
  WorkerOrder(this._order);
  
  Order get order => _order;
  

  String get id => _order.id;
  String get serviceTitle => _order.serviceTitle;
  double get price => _order.price;
  String get clientName => _order.clientName;
  String get clientAvatarUrl => _order.clientAvatarUrl ?? '';
  double get distance => _order.distance ?? 0;
  String get address => _order.address;
  DateTime get createdAt => _order.createdAt;
  OrderRequestType get requestType => _order.requestType;
  OrderStatus get status => _order.status;
  DateTime? get scheduledAt => _order.scheduledAt;
  String? get description => _order.description;
  double? get latitude => _order.latitude;
  double? get longitude => _order.longitude;
  
  PaymentStatus get paymentStatus => _order.paymentStatus;
  bool get isPaid => _order.paymentStatus == PaymentStatus.paid;
  
  String get statusDisplayName {
    switch (_order.status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.in_progress:
        return 'In Progress';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.rejected:
        return 'Rejected';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
  
  factory WorkerOrder.fromJson(Map<String, dynamic> json) {
    return WorkerOrder(Order.fromJson(json));
  }
  
  Map<String, dynamic> toJson() => _order.toJson();
}