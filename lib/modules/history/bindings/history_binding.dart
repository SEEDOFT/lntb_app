import 'package:get/get.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';
import '../controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(
      () => HistoryController(repository: Get.find<DeviceRepository>()),
    );
  }
}
