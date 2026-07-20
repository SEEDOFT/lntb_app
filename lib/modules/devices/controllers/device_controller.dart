import 'package:get/get.dart';
import 'package:lntb_app/core/network/api_client.dart';

class DeviceController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final isLoading = false.obs;

  // Placeholders for devices matching the mockup
  final ownedDevices = [
    {'name': 'Smart Farm #1', 'mac': 'AA:BB:CC:DD:EE:FF', 'is_online': true},
    {
      'name': 'Greenhouse Controller',
      'mac': '11:22:33:44:55:66',
      'is_online': false,
    },
  ].obs;

  final sharedDevices = [
    {'name': "Dara's Farm", 'mac': 'AA:11:BB:22:CC:33', 'is_online': true},
  ].obs;

  void fetchDevices() {
    // TODO: Implement API call to GET /api/v1/devices
  }

  void goToAddDevice() {
    Get.toNamed('/claim');
  }
}
