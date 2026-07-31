import 'package:flutter_test/flutter_test.dart';
import 'package:lntb_app/core/translations/control_type_labels.dart';

void main() {
  group('controlTypeKey', () {
    final cases = {
      'irrigation.start': 'irrigation_start',
      'irrigation.stop': 'irrigation_stop',
      'fan.start': 'fan_start',
      'fan.stop': 'fan_stop',
      'roof.open': 'roof_open',
      'roof.close': 'roof_close',
      'camera.capture': 'camera_capture',
    };

    cases.forEach((code, expected) {
      test('maps $code to $expected', () {
        expect(controlTypeKey(code), expected);
      });
    });
  });
}
