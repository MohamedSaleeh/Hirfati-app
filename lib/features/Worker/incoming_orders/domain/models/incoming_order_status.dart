enum IncomingOrderStatus {
  pending,
  accepted,
  rejected;

  String get displayName {
    switch (this) {
      case IncomingOrderStatus.pending:
        return 'PENDING';
      case IncomingOrderStatus.accepted:
        return 'ACCEPTED';
      case IncomingOrderStatus.rejected:
        return 'REJECTED';
    }
  }
}
