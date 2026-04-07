import 'dart:math';

class DistanceUtils {
  // حساب المسافة بين نقطتين باستخدام Haversine formula
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double R = 6371; // نصف قطر الأرض بالكيلومترات

    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // المسافة بالكيلومترات
  }

  static double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  // تنسيق المسافة للعرض
  static String formatDistance(double distance) {
    if (distance < 1) {
      return '${(distance * 1000).toInt()} m';
    }
    return '${distance.toStringAsFixed(1)} km';
  }
}
