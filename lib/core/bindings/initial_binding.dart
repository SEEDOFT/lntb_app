import 'package:get/get.dart';
import 'package:lntb_app/core/network/api_client.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient(), permanent: true);
  }
}
