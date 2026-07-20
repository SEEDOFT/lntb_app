import 'package:get/get.dart';
import '../controllers/shared_users_controller.dart';

class SharedUsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SharedUsersController>(() => SharedUsersController());
  }
}
