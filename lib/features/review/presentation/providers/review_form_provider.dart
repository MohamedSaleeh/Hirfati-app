import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'review_rating_provider.dart';

// ✅ Provider للـ Form (يحتوي على منطق التحقق)
final reviewFormProvider = Provider.autoDispose<FormGroup>((ref) {
  return FormGroup({'comment': FormControl<String>()});
});

// ✅ Provider لمراقبة قيمة التعليق
final reviewCommentValueProvider = Provider.autoDispose<String?>((ref) {
  final form = ref.watch(reviewFormProvider);
  final value = form.control('comment').value;
  return value?.toString();
});

// ✅ Provider لمراقبة صحة النموذج
final reviewFormIsValidProvider = Provider.autoDispose<bool>((ref) {
  final rating = ref.watch(reviewRatingProvider);
  return rating > 0;
});
