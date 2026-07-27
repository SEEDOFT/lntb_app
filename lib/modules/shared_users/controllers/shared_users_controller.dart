import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';

class SharedUsersController extends GetxController {
  final repository = Get.find<DeviceRepository>();
  late final DeviceModel device;
  final users = <DeviceAccess>[].obs;
  final inputController = TextEditingController();
  final isLoading = false.obs;
  static const maxShared = 5;

  @override
  void onInit() {
    super.onInit();
    device = Get.arguments as DeviceModel;
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      users.assignAll(await repository.getSharedUsers(device.id));
    } catch (error) {
      Get.snackbar('load_failed'.tr, error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> grantAccess() async {
    if (inputController.text.trim().isEmpty) return;
    if (users.length >= maxShared) {
      Get.snackbar('limit_reached'.tr, 'five_user_limit'.tr);
      return;
    }
    isLoading.value = true;
    try {
      await repository.grantAccess(device.id, inputController.text);
      inputController.clear();
      await load();
    } catch (error) {
      Get.snackbar('share_failed'.tr, error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> revoke(DeviceAccess access) async {
    await repository.revokeAccess(device.id, access.id);
    users.remove(access);
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}
