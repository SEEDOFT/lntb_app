import 'package:get/get.dart';
import 'package:lntb_app/core/repositories/account_repository.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';
import 'package:lntb_app/modules/claim/controllers/claim_controller.dart';

class ClaimBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClaimController>(
      () => ClaimController(
        repository: Get.find<DeviceRepository>(),
        accounts: Get.find<AccountRepository>(),
      ),
    );
  }
}
