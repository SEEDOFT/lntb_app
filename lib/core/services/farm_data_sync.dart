import 'package:lntb_app/core/models/farm/farm_models.dart';

abstract interface class FarmSnapshotCache {
  Future<FarmDashboard?> readDashboard(int farmId);
  Future<void> writeDashboard(int farmId, FarmDashboard dashboard);
  Future<void> clearUserData();
}

abstract interface class FarmRealtimeGateway {
  Future<void> connect();
  Future<void> subscribeToFarm(
    int farmId, {
    required void Function(Map<String, dynamic> event) onEvent,
  });
  Future<void> unsubscribeFromFarm(int farmId);
  Future<void> disconnect();
}

/// Used until the Drift database and Reverb transport are configured.
/// Repositories continue to return API empty/unavailable states without
/// introducing fixture data.
final class DisabledFarmSnapshotCache implements FarmSnapshotCache {
  @override
  Future<void> clearUserData() async {}

  @override
  Future<FarmDashboard?> readDashboard(int farmId) async => null;

  @override
  Future<void> writeDashboard(
    int farmId,
    FarmDashboard dashboard,
  ) async {}
}

final class DisabledFarmRealtimeGateway implements FarmRealtimeGateway {
  @override
  Future<void> connect() async {}

  @override
  Future<void> disconnect() async {}

  @override
  Future<void> subscribeToFarm(
    int farmId, {
    required void Function(Map<String, dynamic> event) onEvent,
  }) async {}

  @override
  Future<void> unsubscribeFromFarm(int farmId) async {}
}
