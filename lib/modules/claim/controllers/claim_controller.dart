import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';
import 'package:lntb_app/modules/claim/controllers/qr_scanner_controller.dart';
import 'package:lntb_app/modules/claim/views/qr_scanner_view.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';
import 'package:lntb_app/routes/app_routes.dart';

class ClaimController extends GetxController {
  final repository = Get.find<DeviceRepository>();
  final formKey = GlobalKey<FormState>();
  final macController = TextEditingController();
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final isLoading = false.obs;

  Future<void> scanBarcode() async {
    final payload = await Get.to<ClaimPayload>(
      () => const QrScannerView(),
      binding: BindingsBuilder(
        () => Get.put<QrScannerController>(QrScannerController()),
      ),
    );

    if (payload == null) return;
    macController.text = payload.macAddress.toUpperCase();
    codeController.text = payload.claimCode;
    nameController.text = payload.name ?? '';
  }

  Future<void> claimDevice() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    isLoading.value = true;
    try {
      final device = await repository.claimDevice(
        macAddress: macController.text.trim().toUpperCase(),
        claimCode: codeController.text.trim(),
        name: nameController.text,
      );
      if (Get.isRegistered<DeviceController>()) {
        await Get.find<DeviceController>().fetchDevices();
      }
      Get.offNamed(Routes.CLAIM_SUCCESS, arguments: device);
    } catch (error) {
      Get.snackbar('claim_failed'.tr, error.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
