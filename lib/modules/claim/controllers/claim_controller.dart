import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/account_repository.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';
import 'package:lntb_app/modules/claim/controllers/qr_scanner_controller.dart';
import 'package:lntb_app/modules/claim/views/qr_scanner_view.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';
import 'package:lntb_app/routes/app_routes.dart';

class ClaimController extends GetxController {
  ClaimController({required this.repository, required this.accounts});

  final DeviceRepository repository;
  final AccountRepository accounts;
  final nameController = TextEditingController();
  final isLoading = false.obs;
  final payload = Rxn<ClaimPayload>();
  final currentUser = Rxn<AppUser>();

  bool get canActivate => payload.value != null && !isLoading.value;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadCurrentUser());
  }

  Future<void> loadCurrentUser() async {
    try {
      currentUser.value = await accounts.getCurrentUser();
    } catch (_) {
      currentUser.value = null;
    }
  }

  Future<void> scanBarcode() async {
    final scanned = await Get.to<ClaimPayload>(
      () => const QrScannerView(),
      binding: BindingsBuilder(
        () => Get.put<QrScannerController>(QrScannerController()),
      ),
    );

    if (scanned != null) setPayload(scanned);
  }

  void setPayload(ClaimPayload value) {
    payload.value = value;
    nameController.text = value.name ?? '';
  }

  void clearSensitiveState() {
    payload.value = null;
    nameController.clear();
  }

  Future<void> claimDevice() async {
    final activation = payload.value;
    if (activation == null || isLoading.value) return;

    isLoading.value = true;
    try {
      final device = await repository.claimDevice(
        deviceReference: activation.deviceReference,
        activationToken: activation.activationToken,
        name: nameController.text,
      );
      clearSensitiveState();
      if (Get.isRegistered<DeviceController>()) {
        await Get.find<DeviceController>().fetchDevices();
      }
      unawaited(Get.offNamed(Routes.CLAIM_SUCCESS, arguments: device));
    } catch (_) {
      clearSensitiveState();
      Get.snackbar('claim_failed'.tr, 'activation_invalid'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    clearSensitiveState();
    nameController.dispose();
    super.onClose();
  }
}
