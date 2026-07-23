import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/shared_users/controllers/shared_users_controller.dart';

class SharedUsersView extends GetView<SharedUsersController> {
  const SharedUsersView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('manage_users'.tr)),
        body: Obx(
          () => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                controller.device.name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              Text(
                '${controller.users.length} / ${SharedUsersController.maxShared} ${'shared_users'.tr}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller.inputController,
                decoration: InputDecoration(
                  labelText: 'phone_or_email'.tr,
                  suffixIcon: IconButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.grantAccess,
                    icon: const Icon(
                      Icons.person_add,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (controller.isLoading.value && controller.users.isEmpty)
                const Center(child: CircularProgressIndicator()),
              if (!controller.isLoading.value && controller.users.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(28),
                  child: Text(
                    'no_shared_users'.tr,
                    textAlign: TextAlign.center,
                  ),
                ),
              ...controller.users.map(
                (access) => Card(
                  elevation: 0,
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(access.user.name),
                    subtitle: Text(access.user.contact),
                    trailing: IconButton(
                      onPressed: () => controller.revoke(access),
                      icon: const Icon(
                        Icons.person_remove_outlined,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'five_user_limit'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
}
