import 'package:get/get.dart';
import 'package:lntb_app/core/constants/api_endpoints.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/core/network/api_response.dart';

class NotificationController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  final isLoading = false.obs;
  final notifications = <dynamic>[].obs;

  // Pagination
  final currentPage = 1.obs;
  final hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      currentPage.value = 1;
      hasMore.value = true;
    }

    if (!hasMore.value) return;

    isLoading.value = true;
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.notifications}?page=${currentPage.value}',
      );

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(response.data);

      if (apiResponse.status.success) {
        final data = apiResponse.data;
        final currentList = refresh ? [] : notifications.toList();

        currentList.addAll(data);
        notifications.value = currentList;

        final lastPage = apiResponse.meta?['last_page'] as int?;

        if (lastPage != null && currentPage.value >= lastPage) {
          hasMore.value = false;
        } else {
          currentPage.value++;
        }
      } else {
        Get.snackbar(
          'Error',
          apiResponse.status.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch notifications: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await _apiClient.patch(
        '${ApiEndpoints.notifications}/$notificationId',
        data: {'status': 'read'},
      );

      // Update local state
      final index = notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        final updatedNotification = Map<String, dynamic>.from(
          notifications[index],
        );
        updatedNotification['status']['code'] = 'read';
        notifications[index] = updatedNotification;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark notification as read.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    // Optimistic UI update
    final index = notifications.indexWhere((n) => n['id'] == notificationId);
    if (index == -1) return;

    final removedItem = notifications[index];
    notifications.removeAt(index);

    try {
      await _apiClient.patch(
        '${ApiEndpoints.notifications}/$notificationId',
        data: {'status': 'deleted'},
      );
    } catch (e) {
      // Revert if failed
      notifications.insert(index, removedItem);
      Get.snackbar(
        'Error',
        'Failed to delete notification.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
