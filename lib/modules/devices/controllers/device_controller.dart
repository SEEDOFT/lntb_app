import 'dart:async';

import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';
import 'package:lntb_app/routes/app_routes.dart';

class DeviceController extends GetxController {
  final DeviceRepository repository = Get.find<DeviceRepository>();
  final isLoading = false.obs;
  final error = RxnString();
  final devices = <DeviceModel>[].obs;

  List<DeviceModel> get ownedDevices =>
      devices.where((item) => item.isOwner && item.isControllable).toList();
  List<DeviceModel> get sharedDevices =>
      devices.where((item) => !item.isOwner && item.isControllable).toList();

  int get onlineCount => devices.where((item) => item.isOnline).length;
  int get ownedCount => ownedDevices.length;
  int get sharedCount => sharedDevices.length;

  /// Groups a device list by normalized placement. Blank placements go into an
  /// "Unassigned" group; non-blank placements are grouped case-insensitively.
  Map<String, List<DeviceModel>> groupByPlacement(List<DeviceModel> list) {
    final groups = <String, List<DeviceModel>>{};
    for (final device in list) {
      final placement = device.placement?.trim() ?? '';
      final key = placement.toLowerCase();
      groups.putIfAbsent(key, () => []).add(device);
    }
    return groups;
  }

  String placementLabel(String key) =>
      key.isEmpty ? 'unassigned'.tr : key;

  @override
  void onInit() {
    super.onInit();
    unawaited(fetchDevices());
  }

  Future<void> fetchDevices() async {
    isLoading.value = true;
    error.value = null;
    try {
      devices.assignAll(await repository.getDevices());
    } catch (exception) {
      error.value = exception.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void open(DeviceModel device) =>
      Get.toNamed(Routes.CONTROL, arguments: device);
  void goToAddDevice() => Get.toNamed(Routes.CLAIM);
}
