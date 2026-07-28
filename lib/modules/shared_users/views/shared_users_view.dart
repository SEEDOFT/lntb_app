import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/shared_users/controllers/shared_users_controller.dart';

class SharedUsersView extends GetView<SharedUsersController> {
  const SharedUsersView({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(title: Text('manage_users'.tr)),
          body: Obx(
            () => RefreshIndicator(
              onRefresh: controller.load,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                  const SizedBox(height: 18),
                  Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'invite_user'.tr,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: controller.inputController,
                            decoration: InputDecoration(
                              hintText: 'invite_contact_hint'.tr,
                              prefixIcon:
                                  const Icon(Icons.alternate_email_rounded),
                            ),
                            onSubmitted: (_) => controller.grantAccess(),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: controller.isGranting.value
                                  ? null
                                  : controller.grantAccess,
                              icon: controller.isGranting.value
                                  ? const SizedBox.square(
                                      dimension: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.person_add),
                              label: Text('send_invite'.tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (controller.isLoading.value && controller.users.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (controller.error.value != null)
                    Column(
                      children: [
                        Text(
                          'load_failed'.tr,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: controller.load,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text('retry'.tr),
                        ),
                      ],
                    )
                  else if (controller.users.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24),
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
                        trailing: controller.revokingIds.contains(access.id)
                            ? const SizedBox.square(
                                dimension: 22,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : IconButton(
                                onPressed: () => _confirmRevoke(access),
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
          ),
        ),
      );

  Future<void> _confirmRevoke(DeviceAccess access) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('revoke_access'.tr),
        content: Text(
          'revoke_access_confirmation'.trParams({
            'name': access.user.name,
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: Text('revoke'.tr),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.revoke(access);
  }
}
