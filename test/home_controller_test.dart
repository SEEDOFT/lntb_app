import 'package:flutter_test/flutter_test.dart';
import 'package:lntb_app/core/models/farm_dashboard_models.dart';
import 'package:lntb_app/core/repositories/farm_dashboard_repository.dart';
import 'package:lntb_app/core/services/notification_display_service.dart';
import 'package:lntb_app/modules/home/controllers/home_controller.dart';

void main() {
  test('loads the first authenticated farm dashboard', () async {
    final repository = _FarmRepositoryFake(
      farms: const [FarmSummary(id: 7, name: 'Sokha Farm', status: 'active')],
      dashboard: _dashboard(),
    );
    final controller = HomeController(
      repository: repository,
      notificationDisplay: NotificationDisplayService(),
    );

    await controller.load();

    expect(repository.requestedFarmId, 7);
    expect(controller.dashboard.value?.farm.name, 'Sokha Farm');
    expect(controller.error.value, isNull);
    expect(controller.isLoading.value, isFalse);
  });

  test('keeps an empty state when the API account has no farm', () async {
    final controller = HomeController(
      repository: _FarmRepositoryFake(farms: const []),
      notificationDisplay: NotificationDisplayService(),
    );

    await controller.load();

    expect(controller.dashboard.value, isNull);
    expect(controller.error.value, isNull);
  });

  test('exposes API failures without creating fallback data', () async {
    final controller = HomeController(
      repository: _FarmRepositoryFake(error: Exception('network unavailable')),
      notificationDisplay: NotificationDisplayService(),
    );

    await controller.load();

    expect(controller.dashboard.value, isNull);
    expect(controller.error.value, contains('network unavailable'));
    expect(controller.isLoading.value, isFalse);
  });
}

FarmDashboard _dashboard() => FarmDashboard(
      farm: const FarmSummary(id: 7, name: 'Sokha Farm', status: 'active'),
      metrics: const [],
      devices: const [],
      activity: const [],
      warnings: const [],
      onlineDeviceCount: 0,
    );

class _FarmRepositoryFake implements FarmDashboardRepository {
  _FarmRepositoryFake({
    this.farms = const [],
    this.dashboard,
    this.error,
  });

  final List<FarmSummary> farms;
  final FarmDashboard? dashboard;
  final Exception? error;
  int? requestedFarmId;
  String? requestedPeriod;

  @override
  Future<List<FarmSummary>> getFarms() async {
    if (error case final failure?) throw failure;
    return farms;
  }

  @override
  Future<FarmDashboard> getDashboard(int farmId, {String? period}) async {
    requestedFarmId = farmId;
    requestedPeriod = period;
    if (error case final failure?) throw failure;
    return dashboard!;
  }
}
