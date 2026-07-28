import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';
import 'package:lntb_app/routes/app_routes.dart';

class DeviceController extends GetxController {
  final DeviceRepository repository = Get.find<DeviceRepository>();
  final isLoading = false.obs;
  final error = RxnString();
  final devices = <DeviceModel>[].obs;
  final selectionMode = false.obs;
  final selectedDeviceIds = <int>{}.obs;
  final pendingCommandDeviceIds = <int>{}.obs;
  final isBatchSubmitting = false.obs;

  List<DeviceModel> get ownedDevices =>
      devices.where((item) => item.isOwner).toList();
  List<DeviceModel> get sharedDevices =>
      devices.where((item) => !item.isOwner).toList();
  List<DeviceModel> get selectedDevices =>
      devices.where((item) => selectedDeviceIds.contains(item.id)).toList();

  List<DeviceZone> get zones => groupDevicesByPlacement(devices);

  @override
  void onInit() {
    super.onInit();
    fetchDevices();
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

  void beginSelection([DeviceModel? device]) {
    selectionMode.value = true;
    if (device != null) toggleSelection(device);
  }

  void toggleSelection(DeviceModel device) {
    if (!device.isOnline) {
      Get.snackbar('device_unavailable'.tr, 'offline_selection_help'.tr);
      return;
    }
    if (selectedDeviceIds.contains(device.id)) {
      selectedDeviceIds.remove(device.id);
    } else {
      selectedDeviceIds.add(device.id);
    }
  }

  void selectZone(DeviceZone zone) {
    selectionMode.value = true;
    selectedDeviceIds.addAll(
      zone.devices
          .where((device) => device.isOnline)
          .map((device) => device.id),
    );
  }

  void clearSelection() => selectedDeviceIds.clear();

  void cancelSelection() {
    selectedDeviceIds.clear();
    selectionMode.value = false;
  }

  Future<BatchControlResult?> sendBatchControl(String controlType) async {
    if (selectedDeviceIds.isEmpty || isBatchSubmitting.value) return null;
    isBatchSubmitting.value = true;
    try {
      final result = await repository.sendBatchControl(
        deviceIds: selectedDeviceIds.toList()..sort(),
        controlType: controlType,
      );
      final acceptedIds = result.results
          .where((item) => item.accepted)
          .map((item) => item.deviceId)
          .toSet();
      pendingCommandDeviceIds.addAll(acceptedIds);
      selectedDeviceIds.removeAll(acceptedIds);
      if (selectedDeviceIds.isEmpty) selectionMode.value = false;
      return result;
    } catch (error) {
      Get.snackbar('command_failed'.tr, error.toString());
      return null;
    } finally {
      isBatchSubmitting.value = false;
    }
  }

  Future<bool> updateDevice(
    DeviceModel device, {
    required String name,
    required String placement,
  }) async {
    try {
      await repository.updateDevice(
        device.id,
        name: name,
        placement: placement,
      );
      await fetchDevices();
      return true;
    } catch (error) {
      Get.snackbar('update_failed'.tr, error.toString());
      return false;
    }
  }
}

List<DeviceZone> groupDevicesByPlacement(Iterable<DeviceModel> devices) {
  final grouped = <String, DeviceZone>{};
  final sorted = [...devices]
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  for (final device in sorted) {
    final placement = device.placement?.trim() ?? '';
    final key = placement.isEmpty ? '_unassigned' : placement.toLowerCase();
    final existing = grouped[key];
    grouped[key] = DeviceZone(
      key: key,
      name: existing?.name ?? placement,
      devices: [...?existing?.devices, device],
    );
  }
  final result = grouped.values.toList()
    ..sort((a, b) {
      if (a.key == '_unassigned') return 1;
      if (b.key == '_unassigned') return -1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  return result;
}
