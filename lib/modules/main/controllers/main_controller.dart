import 'package:get/get.dart';

class MainController extends GetxController {
  static const homeIndex = 0;
  static const devicesIndex = 1;
  static const historyIndex = 2;
  static const profileIndex = 3;
  static const pageCount = 4;

  final currentIndex = homeIndex.obs;

  void changePage(int index) => currentIndex.value = switch (index) {
        >= homeIndex && < pageCount => index,
        _ => currentIndex.value,
      };
}
