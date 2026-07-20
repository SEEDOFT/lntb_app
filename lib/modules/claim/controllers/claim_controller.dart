import 'package:get/get.dart';
import 'package:lntb_app/core/network/api_client.dart';

class ClaimController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  final isLoading = false.obs;

  void scanBarcode() {
    Get.snackbar(
      'Scanner',
      'Barcode scanning will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void claimDevice(String mac, String code, String name) async {
    isLoading.value = true;
    // Simulate API call for claim
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;

    Get.back(); // Go back to Devices view on success
    Get.snackbar(
      'Success',
      'Device successfully claimed!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
