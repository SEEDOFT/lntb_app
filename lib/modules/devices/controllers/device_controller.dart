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
      devices.where((item) => item.isOwner).toList();
  List<DeviceModel> get sharedDevices =>
      devices.where((item) => !item.isOwner).toList();

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
}
