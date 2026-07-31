import 'dart:async';

import 'package:get/get.dart';
import 'package:lntb_app/core/models/farm_dashboard_models.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/farm_dashboard_repository.dart';
import 'package:lntb_app/routes/app_routes.dart';

class HomeController extends GetxController {
  HomeController({FarmDashboardRepository? repository})
      : repository = repository ?? Get.find<FarmDashboardRepository>();

  final FarmDashboardRepository repository;
  final dashboard = Rxn<FarmDashboard>();
  final isLoading = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    unawaited(load());
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;
    try {
      final farms = await repository.getFarms();
      dashboard.value =
          farms.isEmpty ? null : await repository.getDashboard(farms.first.id);
    } catch (exception) {
      error.value = exception.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void openDevice(DeviceModel device) =>
      Get.toNamed(Routes.CONTROL, arguments: device);
}
