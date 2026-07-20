import 'package:get/get.dart';
import 'package:lntb_app/modules/claim/controllers/claim_controller.dart';

class ClaimBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClaimController>(() => ClaimController());
  }
}
