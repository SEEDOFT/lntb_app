import 'package:flutter_test/flutter_test.dart';
import 'package:lntb_app/modules/main/controllers/main_controller.dart';
import 'package:lntb_app/routes/app_pages.dart';

void main() {
  test('main navigation exposes four single-farm product tabs', () {
    expect(MainController.homeIndex, 0);
    expect(MainController.devicesIndex, 1);
    expect(MainController.historyIndex, 2);
    expect(MainController.profileIndex, 3);
    expect(MainController.pageCount, 4);
  });

  test('main navigation rejects indexes outside its four tabs', () {
    final controller = MainController()
      ..changePage(MainController.devicesIndex);

    controller
      ..changePage(-1)
      ..changePage(MainController.pageCount);

    expect(controller.currentIndex.value, MainController.devicesIndex);
  });

  test('route table does not expose multi-farm feature routes', () {
    final routeNames = AppPages.pages.map((page) => page.name);

    expect(routeNames.where((name) => name.startsWith('/farm/')), isEmpty);
  });
}
