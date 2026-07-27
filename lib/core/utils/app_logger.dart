import 'package:flutter/foundation.dart';

class AppLogger {
  static void info(String message) {
    if (kDebugMode) {
      debugPrint('[INFO] [${DateTime.now().toIso8601String()}] $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('[WARNING] [${DateTime.now().toIso8601String()}] ⚠️ $message');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    debugPrint('[ERROR] [${DateTime.now().toIso8601String()}] ❌ $message');
    if (error != null) {
      debugPrint('Error Details: $error');
    }
    if (stackTrace != null) {
      debugPrint('StackTrace:\n$stackTrace');
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      debugPrint('[DEBUG] [${DateTime.now().toIso8601String()}] 🔍 $message');
    }
  }
}
