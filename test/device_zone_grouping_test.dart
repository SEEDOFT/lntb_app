import 'package:flutter_test/flutter_test.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';

void main() {
  test('groups trimmed case-equivalent placement and keeps unassigned last',
      () {
    const devices = [
      DeviceModel(
        id: 1,
        name: 'Controller B',
        placement: ' greenhouse A ',
        macAddress: '02:00:00:00:00:01',
        status: 'active',
        accessRole: 'owner',
      ),
      DeviceModel(
        id: 2,
        name: 'Controller A',
        placement: 'Greenhouse A',
        macAddress: '02:00:00:00:00:02',
        status: 'active',
        accessRole: 'shared',
      ),
      DeviceModel(
        id: 3,
        name: 'Controller C',
        placement: ' ',
        macAddress: '02:00:00:00:00:03',
        status: 'active',
        accessRole: 'owner',
      ),
    ];

    final zones = groupDevicesByPlacement(devices);

    expect(zones, hasLength(2));
    expect(zones.first.key, 'greenhouse a');
    expect(zones.first.name, 'Greenhouse A');
    expect(zones.first.devices.map((device) => device.id), [2, 1]);
    expect(zones.last.key, '_unassigned');
    expect(zones.last.devices.single.id, 3);
  });
}
