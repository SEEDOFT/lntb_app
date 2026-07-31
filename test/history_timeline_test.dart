import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/translations/app_translations.dart';
import 'package:lntb_app/core/utils/unit_formatter.dart';
import 'package:lntb_app/modules/history/widgets/control_timeline_view_timeline_item.dart';

void main() {
  setUpAll(() {
    Get.testMode = true;
    Get.addTranslations(AppTranslations().keys);
  });

  test('localizedUnit returns Khmer words in Khmer locale', () async {
    await Get.updateLocale(const Locale('km', 'KH'));
    expect(localizedUnit('m3'), 'ម៉ែត្រគូប');
    expect(localizedUnit('kWh'), 'គីឡូវ៉ាត់ម៉ោង');
    expect(localizedUnit('°C'), 'អង្សារសេ');
    await Get.updateLocale(const Locale('en', 'US'));
  });
  test('formatRuntime renders hours, minutes, and seconds', () {
    expect(
      formatRuntime(const Duration(hours: 2, minutes: 5)),
      '2h 05m',
    );
    expect(
      formatRuntime(const Duration(minutes: 45, seconds: 20)),
      '45m 20s',
    );
    expect(formatRuntime(const Duration(seconds: 30)), '30s');
    expect(formatRuntime(null), '—');
  });

  test('formatRuntime uses Khmer unit words in the Khmer locale', () async {
    await Get.updateLocale(const Locale('km', 'KH'));
    expect(
      formatRuntime(const Duration(hours: 2, minutes: 5)),
      '2ម៉ោង 05នាទី',
    );
    expect(
      formatRuntime(const Duration(minutes: 45, seconds: 20)),
      '45នាទី 20វិនាទី',
    );
    expect(formatRuntime(const Duration(seconds: 30)), '30វិនាទី');
    await Get.updateLocale(const Locale('en', 'US'));
  });

  test('formatEnergyKwh renders kWh with three decimals', () {
    expect(formatEnergyKwh(0.0425), '0.043 kWh');
    expect(formatEnergyKwh(null), '—');
  });

  test('timeline entry maps seeded device names to Khmer', () {
    final entry = HistoryTimelineEntry(
      record: ControlRecord(
        id: 1,
        deviceId: 1,
        controlType: 'fan.start',
        status: 'completed',
        requestedAt: DateTime(2026, 7, 31, 8),
        deviceName: 'Exhaust Fan',
      ),
    );

    expect(entry.deviceDisplayName, 'កង្ហារបញ្ចេញខ្យល់');
  });

  test('timeline entry falls back to the original device name', () {
    final entry = HistoryTimelineEntry(
      record: ControlRecord(
        id: 2,
        deviceId: 1,
        controlType: 'fan.stop',
        status: 'completed',
        requestedAt: DateTime(2026, 7, 31, 9),
        deviceName: 'Custom Fan',
      ),
    );

    expect(entry.deviceDisplayName, 'Custom Fan');
  });
}
