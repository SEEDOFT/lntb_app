import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/services/language_service.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/routes/app_routes.dart';
import 'package:lntb_app/modules/profile/controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'profile'.tr,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(
                'profile_subtitle'.tr,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        body: Obx(
          () => ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            children: [
              Container(
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
                      color: AppColors.primary.withValues(alpha: .2),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .16),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .35),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.user.value?.name ?? '...',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            controller.user.value?.contact ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFD8FFE5),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Card(
                elevation: 0,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      leading: const _ProfileIcon(
                        icon: Icons.notifications_none_rounded,
                      ),
                      title: Text('notifications'.tr),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textMuted,
                      ),
                      onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                    ),
                    const Divider(height: 1, indent: 74),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      leading: const _ProfileIcon(
                        icon: Icons.language_rounded,
                      ),
                      title: Text('language'.tr),
                      subtitle: Text(
                        LanguageService.to.isKhmer ? 'ភាសាខ្មែរ' : 'English',
                      ),
                      trailing: const Icon(
                        Icons.swap_horiz_rounded,
                        color: AppColors.primary,
                      ),
                      onTap: LanguageService.to.toggleLanguage,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed:
                    controller.isLoading.value ? null : controller.logout,
                icon: const Icon(Icons.logout),
                label: Text('logout'.tr),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  minimumSize: const Size.fromHeight(52),
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.primary),
      );
}
