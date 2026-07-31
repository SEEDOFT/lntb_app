import 'package:get/get.dart';

/// Returns the localized display string for a backend unit code.
///
/// Khmer uses full words (e.g. "ម៉ែត្រគូប"); other locales use the short
/// symbol.
String localizedUnit(String unit) => switch (unit) {
      'm3' || 'm³' => 'unit_cubic_meter'.tr,
      'kWh' => 'unit_kwh'.tr,
      '°C' || 'oC' || '°c' => 'unit_celsius'.tr,
      _ => unit,
    };
