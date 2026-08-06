import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

  static void info(String message) {
    if (kDebugMode) {
      debugPrint(_sanitize(message));
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('Warning: ${_sanitize(message)}');
    }
  }

  static void error(Object error, {StackTrace? stackTrace, String? message}) {
    if (!kDebugMode) return;

    final context = message == null ? 'Error' : _sanitize(message);
    debugPrint('$context: ${_sanitize(error.toString())}');
    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace, label: context);
    }
  }

  static String _sanitize(String value) {
    var sanitized = value;

    final patterns = [
      RegExp(
        r'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+',
        caseSensitive: false,
      ),
      RegExp(
        r'(token|secret|password|pin|private[_-]?key|authorization|apikey|api[_-]?key|card|cvv)\s*[:=]\s*[^,\s}\]]+',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      sanitized = sanitized.replaceAllMapped(pattern, (match) {
        final text = match.group(0) ?? '';
        final separatorIndex = text.indexOf(RegExp(r'[:=]'));
        if (separatorIndex == -1) return '[redacted]';
        return '${text.substring(0, separatorIndex + 1)} [redacted]';
      });
    }

    return sanitized;
  }
}
