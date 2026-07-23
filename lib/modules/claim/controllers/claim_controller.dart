import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';
import 'package:lntb_app/routes/app_routes.dart';

class ClaimController extends GetxController {
  final repository = Get.find<DeviceRepository>();
  final formKey = GlobalKey<FormState>();
  final macController = TextEditingController();
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final isLoading = false.obs;
  bool _handled = false;

  ClaimPayload parseQr(String raw) {
    return ClaimPayload.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  void scanBarcode() {
    _handled = false;
    Get.to(
      () => Scaffold(
        appBar: AppBar(title: Text('scan_qr'.tr)),
        body: MobileScanner(
          onDetect: (capture) {
            if (_handled) return;
            final raw = capture.barcodes.isEmpty
                ? null
                : capture.barcodes.first.rawValue;
            if (raw == null) return;
            try {
              final payload = parseQr(raw);
              _handled = true;
              macController.text = payload.macAddress;
              codeController.text = payload.claimCode;
              nameController.text = payload.name ?? '';
              Get.back();
            } catch (_) {
              Get.snackbar('invalid_qr'.tr, 'manual_entry_help'.tr);
            }
          },
        ),
      ),
    );
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

  @override
  void onClose() {
    macController.dispose();
    codeController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
