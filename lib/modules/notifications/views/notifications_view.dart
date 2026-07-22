import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import '../controllers/notification_controller.dart';

class NotificationsView extends GetView<NotificationController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.inputFill,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text(
              'No notifications yet.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchNotifications(refresh: true),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.notifications.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.notifications.length) {
                if (controller.hasMore.value) {
                  controller.fetchNotifications();
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }

              final notification = controller.notifications[index];
              final isUnread = notification['status']['code'] == 'unread';

              return Dismissible(
                key: Key(notification['id'].toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: AppColors.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  controller.deleteNotification(notification['id']);
                },
                child: Container(
                  color: isUnread ? Colors.white : AppColors.inputFill,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: isUnread
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      child: Icon(
                        _getIconForType(notification['type']['code']),
                        color: isUnread ? AppColors.primary : Colors.grey,
                      ),
                    ),
                    title: Text(
                      notification['title'],
                      style: TextStyle(
                        fontWeight: isUnread
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      notification['body'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    onTap: () {
                      if (isUnread) {
                        controller.markAsRead(notification['id']);
                      }
                      _showNotificationDetails(context, notification);
                    },
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  IconData _getIconForType(String typeCode) {
    switch (typeCode) {
      case 'welcome':
        return Icons.celebration;
      case 'alert':
        return Icons.warning_amber_rounded;
      case 'system':
      default:
        return Icons.info_outline;
    }
  }

  void _showNotificationDetails(
    BuildContext context,
    Map<String, dynamic> notification,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Icon(
                      _getIconForType(notification['type']['code']),
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      notification['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                notification['body'],
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24), // SafeArea bottom padding alternative
            ],
          ),
        );
      },
    );
  }
}
