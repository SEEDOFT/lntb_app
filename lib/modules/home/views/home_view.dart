import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/constants/app_assets.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';
import 'package:lntb_app/modules/notifications/controllers/notification_controller.dart';
import 'package:lntb_app/modules/profile/controllers/profile_controller.dart';
import 'package:lntb_app/routes/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final devices = Get.find<DeviceController>();
    final profile = Get.find<ProfileController>();
    final notifications = Get.find<NotificationController>();

    return Scaffold(
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
                  Obx(() => _DeviceOverview(devices: devices)),
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'quick_actions'.tr),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickAction(
                          icon: Icons.qr_code_scanner_rounded,
                          label: 'claim_device'.tr,
                          color: AppColors.primary,
                          onTap: () => Get.toNamed(Routes.CLAIM),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickAction(
                          icon: Icons.task_alt_rounded,
                          label: 'today_tasks'.tr,
                          color: AppColors.info,
                          onTap: () => Get.toNamed(Routes.FARM_TASKS),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickAction(
                          icon: Icons.water_drop_outlined,
                          label: 'irrigation'.tr,
                          color: AppColors.primaryDark,
                          onTap: () => Get.toNamed(Routes.IRRIGATION),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  _SectionHeader(
                    title: 'recent_devices'.tr,
                    actionLabel: 'claim_device'.tr,
                    onAction: () => Get.toNamed(Routes.CLAIM),
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (devices.devices.isEmpty) {
                      return _EmptyDeviceCard(
                        onAdd: () => Get.toNamed(Routes.CLAIM),
                      );
                    }

                    return Column(
                      children: devices.devices
                          .take(4)
                          .map(
                            (device) => _DeviceCardItem(
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
    );
  }
}

class _DeviceOverview extends StatelessWidget {
  const _DeviceOverview({required this.devices});

  final DeviceController devices;

  @override
  Widget build(BuildContext context) {
    final total = devices.devices.length;
    final online = devices.devices.where((device) => device.isOnline).length;
    final owned = devices.devices.where((device) => device.isOwner).length;
    final shared = total - owned;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .22),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'device_overview'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$total ${'total_devices'.tr}',
                      style: const TextStyle(
                        color: Color(0xFFD8FFE5),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.hub_outlined,
                  color: Colors.white,
                  size: 27,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              _OverviewMetric(
                value: '$online',
                label: 'online'.tr,
                icon: Icons.wifi_rounded,
              ),
              _OverviewMetric(
                value: '$owned',
                label: 'owned'.tr,
                icon: Icons.verified_user_outlined,
              ),
              _OverviewMetric(
                value: '$shared',
                label: 'shared'.tr,
                icon: Icons.people_outline_rounded,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Get.toNamed(Routes.CLAIM),
              style: FilledButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.add_rounded),
              label: Text('claim_device'.tr),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFB9F5CC), size: 20),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFD8FFE5),
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel ?? ''),
            ),
        ],
      );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            constraints: const BoxConstraints(minHeight: 112),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .11),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(height: 9),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _DeviceCardItem extends StatelessWidget {
  const _DeviceCardItem({
    required this.name,
    required this.mac,
    required this.role,
    required this.isOnline,
    required this.onTap,
  });

  final String name;
  final String mac;
  final String role;
  final bool isOnline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(AppAssets.logo),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        mac,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        role,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _StatusBadge(isOnline: isOnline),
              ],
            ),
          ),
        ),
      );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color:
              isOnline ? AppColors.onlineBadgeBg : AppColors.offlineBadgeBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: isOnline
                    ? AppColors.onlineBadgeText
                    : AppColors.offlineBadgeText,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              isOnline ? 'online'.tr : 'offline'.tr,
              style: TextStyle(
                color: isOnline
                    ? AppColors.onlineBadgeText
                    : AppColors.offlineBadgeText,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
}

class _EmptyDeviceCard extends StatelessWidget {
  const _EmptyDeviceCard({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.router_outlined,
                size: 30,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'no_devices'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: Text('claim_device'.tr),
            ),
          ],
        ),
      );
}
