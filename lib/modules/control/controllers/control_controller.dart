import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';
import 'package:lntb_app/modules/history/controllers/history_controller.dart';
import 'package:lntb_app/modules/home/controllers/home_controller.dart';
import 'package:lntb_app/routes/app_routes.dart';

class ControlController extends GetxController {
  final repository = Get.find<DeviceRepository>();
  late final DeviceModel device;
  final history = <ControlRecord>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    device = Get.arguments as DeviceModel;
    unawaited(refreshHistory());
  }

  Future<void> refreshHistory() async {
    isLoading.value = true;
    try {
      history.assignAll(
        await repository.getControlHistory(deviceId: device.id),
      );
    } catch (error) {
      if (!_handleRevokedAccess(error)) {
        Get.snackbar('load_failed'.tr, error.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  bool latestState(String start, String stop) {
    final record = history.firstWhereOrNull(
      (item) => item.controlType == start || item.controlType == stop,
    );
    return record?.controlType == start;
  }

  Future<void> sendCommand(String commandType) async {
    isLoading.value = true;
    try {
      history.insert(
        0,
        await repository.sendControl(device.id, commandType),
      );
      if (Get.isRegistered<HomeController>()) {
        unawaited(Get.find<HomeController>().load());
      }
      if (Get.isRegistered<HistoryController>()) {
        unawaited(Get.find<HistoryController>().load());
      }
    } catch (error) {
      if (!_handleRevokedAccess(error)) {
        Get.snackbar('command_failed'.tr, error.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  void manageUsers() => Get.toNamed(Routes.SHARED_USERS, arguments: device);

  bool _handleRevokedAccess(Object error) {
    if (error is! DioException || error.response?.statusCode != 403) {
      return false;
    }
    if (Get.isRegistered<DeviceController>()) {
      unawaited(Get.find<DeviceController>().fetchDevices());
    }
    Get.back();
    Get.snackbar('access_revoked'.tr, 'access_revoked_message'.tr);
    return true;
  }
}
