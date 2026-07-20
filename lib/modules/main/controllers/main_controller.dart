import 'package:get/get.dart';

class MainController extends GetxController {
  final currentIndex = 1.obs; // Devices is selected by default in mockup

  void changePage(int index) {
    currentIndex.value = index;
  }
}
