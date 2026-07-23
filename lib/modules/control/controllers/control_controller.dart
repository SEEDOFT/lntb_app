import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';
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
    refreshHistory();
  }

  Future<void> refreshHistory() async {
    isLoading.value = true;
    try {
      history.assignAll(
        await repository.getControlHistory(deviceId: device.id),
      );
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
    } catch (error) {
      Get.snackbar('command_failed'.tr, error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void manageUsers() => Get.toNamed(Routes.SHARED_USERS, arguments: device);
}
