import 'package:flutter/foundation.dart';

enum AppDataSource { demo, api }

abstract final class AppDataSourceConfig {
  static const String _value = String.fromEnvironment(
    'LNTB_DATA_SOURCE',
    defaultValue: 'demo',
  );

  static AppDataSource get current {
    final source = switch (_value.toLowerCase()) {
      'demo' => AppDataSource.demo,
      'api' => AppDataSource.api,
      _ => throw StateError(
          'Unsupported LNTB_DATA_SOURCE "$_value". Use demo or api.',
        ),
    };
    if (kReleaseMode && source == AppDataSource.demo) {
      throw StateError('Demo data is disabled in release builds.');
    }
    return source;
  }

  static bool get isDemo => current == AppDataSource.demo;
}
