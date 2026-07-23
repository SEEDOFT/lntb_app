import 'package:get/get.dart';
import 'package:lntb_app/modules/shared_users/controllers/shared_users_controller.dart';

class SharedUsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SharedUsersController>(() => SharedUsersController());
  }
}
