import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';

class SharedUsersController extends GetxController {
  final repository = Get.find<DeviceRepository>();
  late final DeviceModel device;
  final users = <DeviceAccess>[].obs;
  final inputController = TextEditingController();
  final isLoading = false.obs;
  final isGranting = false.obs;
  final revokingIds = <int>{}.obs;
  final error = RxnString();
  static const maxShared = 5;

  @override
  void onInit() {
    super.onInit();
    device = Get.arguments as DeviceModel;
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;
    try {
      users.assignAll(await repository.getSharedUsers(device.id));
    } catch (error) {
      this.error.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> grantAccess() async {
    final identity = _normalizeIdentity(inputController.text);
    if (identity.isEmpty) return;
    if (users.length >= maxShared) {
      Get.snackbar('limit_reached'.tr, 'five_user_limit'.tr);
      return;
    }
    isGranting.value = true;
    try {
      await repository.grantAccess(device.id, identity);
      inputController.clear();
      await load();
      await _refreshDevices();
    } catch (error) {
      Get.snackbar('share_failed'.tr, error.toString());
    } finally {
      isGranting.value = false;
    }
  }

  Future<void> revoke(DeviceAccess access) async {
    if (revokingIds.contains(access.id)) return;
    revokingIds.add(access.id);
    try {
      await repository.revokeAccess(device.id, access.id);
      users.removeWhere((item) => item.id == access.id);
      await _refreshDevices();
    } catch (error) {
      Get.snackbar('revoke_failed'.tr, error.toString());
    } finally {
      revokingIds.remove(access.id);
    }
  }

  String _normalizeIdentity(String value) {
    final trimmed = value.trim();
    if (trimmed.contains('@')) return trimmed.toLowerCase();
    return trimmed.replaceAll(RegExp(r'[\s\-()]'), '');
  }

  Future<void> _refreshDevices() async {
    if (Get.isRegistered<DeviceController>()) {
      await Get.find<DeviceController>().fetchDevices();
    }
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}
