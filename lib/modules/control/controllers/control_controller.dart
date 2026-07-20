import 'package:get/get.dart';
import 'package:lntb_app/core/network/api_client.dart';

class ControlController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final isLoading = false.obs;

  // Mock device info
  final deviceName = 'Smart Farm #1'.obs;
  final deviceMac = 'AA:BB:CC:DD:EE:FF'.obs;
  final isOnline = true.obs;

  // Mock recent activity
  final recentActivity = [
    {
      'action': 'Start Irrigation',
      'time': 'Today, 9:30 AM',
      'status': 'Completed',
      'type': 'irrigation.start',
    },
    {
      'action': 'Fan On',
      'time': 'Today, 10:00 AM',
      'status': 'Completed',
      'type': 'fan.start',
    },
    {
      'action': 'Stop Irrigation',
      'time': 'Today, 10:10 AM',
      'status': 'Failed',
      'type': 'irrigation.stop',
    },
    {
      'action': 'Fan Off',
      'time': 'Today, 10:20 AM',
      'status': 'Completed',
      'type': 'fan.stop',
    },
  ].obs;

  void sendCommand(String commandType) async {
    isLoading.value = true;
    Get.snackbar(
      'Sending Command',
      'Executing $commandType...',
      snackPosition: SnackPosition.BOTTOM,
    );

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Add to activity feed
    recentActivity.insert(0, {
      'action': commandType.replaceAll('.', ' ').capitalizeFirst ?? commandType,
      'time': 'Just now',
      'status': 'Completed',
      'type': commandType,
    });

    isLoading.value = false;
  }
}
