import 'package:get/get.dart';
import '../controllers/harvest_controller.dart';

class HarvestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HarvestController>(() => HarvestController());
  }
}
