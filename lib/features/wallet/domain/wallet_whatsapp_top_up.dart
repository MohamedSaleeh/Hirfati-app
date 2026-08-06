class WalletWhatsAppTopUp {
  static String normalizeNumber(String value) {
    var normalized = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (normalized.startsWith('00')) normalized = normalized.substring(2);
    return normalized;
  }

  static bool isValidNumber(String value) {
    return RegExp(r'^\d{8,15}$').hasMatch(value);
  }

  static String buildArabicMessage({
    required String userId,
    String? fullName,
    String? phone,
    String? amount,
  }) {
    final safeName = _valueOrPlaceholder(fullName);
    final safePhone = _valueOrPlaceholder(phone);
    final safeAmount = _valueOrPlaceholder(amount);
    return 'مرحبًا، أرغب في شحن رصيدي في تطبيق حرفتي.\n\n'
        'الاسم: $safeName\n'
        'معرف الحساب: $userId\n'
        'رقم الهاتف: $safePhone\n'
        'المبلغ المطلوب: $safeAmount USD\n\n'
        'يرجى تزويدي بتعليمات الدفع.';
  }

  static Uri buildUri({required String number, required String message}) {
    return Uri.https('wa.me', '/${normalizeNumber(number)}', {'text': message});
  }

  static Uri buildFallbackUri({
    required String number,
    required String message,
  }) {
    return Uri.https('api.whatsapp.com', '/send', {
      'phone': normalizeNumber(number),
      'text': message,
    });
  }

  static String _valueOrPlaceholder(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? '________' : text;
  }
}
