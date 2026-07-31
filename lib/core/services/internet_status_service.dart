import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lntb_app/routes/app_routes.dart';

class InternetStatusService extends GetxService with WidgetsBindingObserver {
  final isOnline = true.obs;
  late final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<InternetStatusService> init() async {
    _connectivity = Connectivity();
    WidgetsBinding.instance.addObserver(this);
    await check(navigate: false);
    _subscription = _connectivity.onConnectivityChanged.listen((_) {
      unawaited(check());
    });
    return this;
  }

  Future<bool> check({bool navigate = true}) async {
    final results = await _connectivity.checkConnectivity();
    final online = results.any((result) => result != ConnectivityResult.none);
    isOnline.value = online;
    if (navigate && !online && Get.currentRoute != Routes.NO_INTERNET) {
      unawaited(Get.toNamed(Routes.NO_INTERNET));
    } else if (navigate && online && Get.currentRoute == Routes.NO_INTERNET) {
      unawaited(Get.offAllNamed(Routes.SPLASH));
    }
    return online;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(check());
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    super.onClose();
  }
}
