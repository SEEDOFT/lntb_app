import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/devices/views/devices_view.dart';
import 'package:lntb_app/modules/farm/views/farm_view.dart';
import 'package:lntb_app/modules/history/views/history_view.dart';
import 'package:lntb_app/modules/home/views/home_view.dart';
import 'package:lntb_app/modules/main/controllers/main_controller.dart';
import 'package:lntb_app/modules/profile/views/profile_view.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) => Obx(
        () => Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              HomeView(),
              FarmView(),
              DevicesView(),
              HistoryView(),
              ProfileView(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: .08),
                  blurRadius: 22,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: NavigationBar(
              selectedIndex: controller.currentIndex.value,
              onDestinationSelected: controller.changePage,
              indicatorColor: AppColors.primaryLight,
              backgroundColor: AppColors.surface,
              elevation: 0,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home_rounded, color: AppColors.primary),
                  label: 'home'.tr,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.eco_outlined),
                  selectedIcon: const Icon(
                    Icons.eco_rounded,
                    color: AppColors.primary,
                  ),
                  label: 'farm'.tr,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.router_outlined),
                  selectedIcon: const Icon(
                    Icons.router_rounded,
                    color: AppColors.primary,
                  ),
                  label: 'devices'.tr,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.history_outlined),
                  selectedIcon: const Icon(Icons.history_rounded, color: AppColors.primary),
                  label: 'history'.tr,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline_rounded),
                  selectedIcon: const Icon(Icons.person_rounded, color: AppColors.primary),
                  label: 'profile'.tr,
                ),
              ],
            ),
          ),
        ),
      );
}
