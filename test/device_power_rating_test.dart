import 'package:flutter_test/flutter_test.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';

void main() {
  test('parses rated_power_watts from device payload', () {
    final device = DeviceModel.fromJson({
      'id': 1,
      'name': 'Water Pump',
      'mac_address': 'AA:BB:CC:DD:EE:FF',
      'status': {'code': 'active'},
      'access_role': 'owner',
      'rated_power_watts': 750,
    });

    expect(device.ratedPowerWatts, 750);
  });

  test('allows missing rated_power_watts', () {
    final device = DeviceModel.fromJson({
      'id': 2,
      'name': 'Fan',
      'mac_address': 'AA:BB:CC:DD:EE:FF',
      'status': {'code': 'active'},
      'access_role': 'owner',
    });

    expect(device.ratedPowerWatts, isNull);
  });
}
