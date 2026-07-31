import 'package:flutter_test/flutter_test.dart';
import 'package:lntb_app/core/models/farm_dashboard_models.dart';

void main() {
  test('parses the complete authenticated dashboard response', () {
    final dashboard = FarmDashboard.fromJson({
      'farm': {
        'id': 9,
        'name': 'Sokha Tomato Farm',
        'location': 'Kandal Province, Cambodia',
        'status': {'code': 'active'},
        'current_crop_cycle': {'crop_name': 'Cherry Tomato'},
      },
      'metrics': [
        {
          'code': 'soil_moisture',
          'value': 54,
          'unit': '%',
          'status': 'normal',
          'recorded_at': '2026-07-31T08:00:00Z',
          'device': {'id': 12, 'name': 'Exhaust Fan'},
        },
      ],
      'devices': [
        {
          'id': 12,
          'name': 'Exhaust Fan',
          'mac_address': '02:00:00:00:10:01',
          'status': {'code': 'active'},
          'type': {'code': 'fan', 'name': 'Fan'},
          'access_role': 'owner',
        },
      ],
      'activity': [
        {
          'id': 14,
          'device_id': 12,
          'device_name': 'Exhaust Fan',
          'control_type': 'fan.start',
          'status': {'code': 'completed'},
          'requested_at': '2026-07-31T07:00:00Z',
        },
      ],
      'warnings': <Map<String, dynamic>>[],
      'online_device_count': 1,
    });

    expect(dashboard.farm.name, 'Sokha Tomato Farm');
    expect(dashboard.farm.cropName, 'Cherry Tomato');
    expect(dashboard.metric('soil_moisture')?.value, 54);
    expect(dashboard.devices.single.id, 12);
    expect(dashboard.devices.single.typeCode, 'fan');
    expect(dashboard.activity.single.controlType, 'fan.start');
    expect(dashboard.onlineDeviceCount, 1);
  });

  test('parses a valid empty dashboard without local fallback data', () {
    final dashboard = FarmDashboard.fromJson({
      'farm': {
        'id': 9,
        'name': 'Empty Farm',
        'status': {'code': 'active'},
      },
      'metrics': <Map<String, dynamic>>[],
      'devices': <Map<String, dynamic>>[],
      'activity': <Map<String, dynamic>>[],
      'warnings': <Map<String, dynamic>>[],
      'online_device_count': 0,
    });

    expect(dashboard.metrics, isEmpty);
    expect(dashboard.devices, isEmpty);
    expect(dashboard.activity, isEmpty);
  });
}
