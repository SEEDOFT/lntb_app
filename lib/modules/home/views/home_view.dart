import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/constants/app_assets.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';
import 'package:lntb_app/modules/devices/views/device_placement_view.dart';
import 'package:lntb_app/modules/history/views/control_timeline_view.dart';
import 'package:lntb_app/modules/notifications/controllers/notification_controller.dart';
import 'package:lntb_app/modules/profile/controllers/profile_controller.dart';
import 'package:lntb_app/routes/app_routes.dart';
import 'package:lntb_app/modules/home/widgets/home_view_device_card_item.dart';
import 'package:lntb_app/modules/home/widgets/home_view_device_overview.dart';
import 'package:lntb_app/modules/home/widgets/home_view_empty_device_card.dart';
import 'package:lntb_app/modules/home/widgets/home_view_quick_action.dart';
import 'package:lntb_app/modules/home/widgets/home_view_section_header.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final devices = Get.find<DeviceController>();
    final profile = Get.find<ProfileController>();
    final notifications = Get.find<NotificationController>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: devices.fetchDevices,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                centerTitle: false,
                backgroundColor: AppColors.background,
                surfaceTintColor: AppColors.background,
                titleSpacing: 16,
                title: Obx(
                  () => Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Image.asset(AppAssets.logo),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'hello'.tr,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              profile.user.value?.name ?? 'app_title'.tr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton.filledTonal(
                      onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.textPrimary,
                      ),
                      icon: Obx(
                        () => Badge.count(
                          count: notifications.unreadCount.value,
                          isLabelVisible: notifications.unreadCount.value > 0,
                          child: const Icon(Icons.notifications_none_rounded),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Obx(
                      () => HomeDeviceOverview(
                        total: devices.devices.length,
                        online: devices.devices.where((d) => d.isOnline).length,
                        owned: devices.devices.where((d) => d.isOwner).length,
                      ),
                    ),
                    const SizedBox(height: 24),
                    HomeSectionHeader(title: 'quick_actions'.tr),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: HomeQuickAction(
                            icon: Icons.qr_code_scanner_rounded,
                            label: 'claim_device'.tr,
                            color: AppColors.primary,
                            onTap: () => Get.toNamed(Routes.CLAIM),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: HomeQuickAction(
                            icon: Icons.map_outlined,
                            label: 'farm_layout'.tr,
                            color: AppColors.info,
                            onTap: () =>
                                Get.to(() => const DevicePlacementView()),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: HomeQuickAction(
                            icon: Icons.history_rounded,
                            label: 'control_log'.tr,
                            color: AppColors.primaryDark,
                            onTap: () =>
                                Get.to(() => const ControlTimelineView()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    HomeSectionHeader(
                      title: 'recent_devices'.tr,
                      actionLabel: 'claim_device'.tr,
                      onAction: () => Get.toNamed(Routes.CLAIM),
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      if (devices.devices.isEmpty) {
                        return HomeEmptyDeviceCard(
                          onAdd: () => Get.toNamed(Routes.CLAIM),
                        );
                      }

                      return Column(
                        children: devices.devices
                            .take(4)
                            .map(
                              (device) => HomeDeviceCardItem(
                                name: device.name,
                                mac: device.macAddress,
                                role: device.isOwner
                                    ? 'owner'.tr
                                    : 'shared_access_role'.tr,
                                isOnline: device.isOnline,
                                onTap: () => devices.open(device),
                              ),
                            )
                            .toList(),
                      );
                    }),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
