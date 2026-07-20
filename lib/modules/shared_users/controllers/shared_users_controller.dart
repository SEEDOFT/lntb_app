import 'package:get/get.dart';
import 'package:lntb_app/core/network/api_client.dart';

class SharedUsersController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final isLoading = false.obs;

  // Mock data matching the mockup
  final users = [
    {'name': 'Sokun', 'email': 'sokun@example.com', 'role': 'Owner'},
    {'name': 'Dara', 'email': 'dara@example.com', 'role': 'Shared'},
    {'name': 'Bora', 'email': 'bora@example.com', 'role': 'Shared'},
  ].obs;

  int get sharedCount => users.where((u) => u['role'] != 'Owner').length;
  final int maxShared = 5;

  void grantAccess(String identifier) async {
    if (identifier.isEmpty) return;
    if (sharedCount >= maxShared) {
      Get.snackbar(
        'Error',
        'Maximum 5 shared users reached.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // API call
    isLoading.value = false;

    users.add({'name': 'New User', 'email': identifier, 'role': 'Shared'});
    Get.snackbar(
      'Success',
      'Access granted successfully.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void revokeAccess(int index) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // API call
    isLoading.value = false;

    users.removeAt(index);
    Get.snackbar(
      'Success',
      'Access revoked.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
