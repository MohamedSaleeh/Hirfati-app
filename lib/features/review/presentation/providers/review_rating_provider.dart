import 'package:flutter_riverpod/legacy.dart';

// ✅ Provider بسيط لقيمة التقييم
final reviewRatingProvider = StateProvider.autoDispose<double>((ref) => 0.0);

// ✅ Provider لحالة الإرسال
final reviewIsSubmittingProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);
