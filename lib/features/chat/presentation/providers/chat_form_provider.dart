import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:reactive_forms/reactive_forms.dart';

// ✅ Provider واحد فقط للـ Form
final chatFormProvider = Provider<FormGroup>((ref) {
  return FormGroup({'message': FormControl<String>(value: '')});
});

// ✅ Notifier بسيط لإدارة حالة النموذج
class ChatFormNotifier extends StateNotifier<bool> {
  final FormGroup _form;

  ChatFormNotifier(this._form) : super(false) {
    _form.control('message').valueChanges.listen((_) => update());
  }

  void update() {
    final value = _form.control('message').value;
    final hasText = value != null && value.toString().trim().isNotEmpty;
    state = hasText;
  }

  void reset() {
    _form.control('message').reset();
    state = false;
  }
}

// ✅ Provider لمراقبة حالة الحقل (فارغ أم لا)
final chatMessageHasTextProvider =
    StateNotifierProvider<ChatFormNotifier, bool>((ref) {
      final form = ref.watch(chatFormProvider);
      return ChatFormNotifier(form);
    });

// ✅ دالة لإعادة تعيين الحقل
final chatFormResetProvider = Provider<void Function()>((ref) {
  final notifier = ref.read(chatMessageHasTextProvider.notifier);
  return () => notifier.reset();
});

// ✅ دالة لتحديث الحالة عند الكتابة
final chatFormUpdateProvider = Provider<void Function()>((ref) {
  final notifier = ref.read(chatMessageHasTextProvider.notifier);
  return () => notifier.update();
});
