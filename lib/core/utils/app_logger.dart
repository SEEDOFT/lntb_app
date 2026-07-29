import 'package:flutter/foundation.dart';

class AppLogger {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _cyan = '\x1B[36m';

  static void info(String message) {
    if (kDebugMode) {
      debugPrint(
        '$_green[INFO]$_reset [${DateTime.now().toIso8601String()}] $message',
      );
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      debugPrint(
        '$_yellow[WARNING]$_reset [${DateTime.now().toIso8601String()}] $message',
      );
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    debugPrint(
      '$_red[ERROR]$_reset [${DateTime.now().toIso8601String()}] $message',
    );
    if (error != null) {
      debugPrint('Error Details: $error');
    }
    if (stackTrace != null) {
      debugPrint('StackTrace:\n$stackTrace');
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      debugPrint(
        '$_cyan[DEBUG]$_reset [${DateTime.now().toIso8601String()}] $message',
      );
    }
  }
}
