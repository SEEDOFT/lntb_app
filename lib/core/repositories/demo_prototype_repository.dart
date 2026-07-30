import 'package:get/get.dart';
import 'package:lntb_app/core/models/prototype/prototype_models.dart';
import 'package:lntb_app/core/repositories/prototype_repositories.dart';

final class DemoPrototypeRepository extends GetxController
    implements
        DashboardRepository,
        TelemetryRepository,
        IrrigationRepository,
        UsageRepository,
        RipenessRepository,
        FarmLogRepository,
        NotificationFeedRepository,
        DeviceHealthRepository {
  static final DateTime fixedNow = DateTime.utc(2026, 7, 30, 8, 0);

  final scenario = DemoScenario.healthy.obs;
  final actuatorStates = <ActuatorKind, ActuatorState>{
    ActuatorKind.pump: ActuatorState.stopped,
    ActuatorKind.fan: ActuatorState.stopped,
    ActuatorKind.roof: ActuatorState.closed,
    ActuatorKind.camera: ActuatorState.stopped,
  }.obs;
  final latestCommands = <ActuatorKind, ZoneCommand>{}.obs;
  final remainingIrrigationMinutes = 0.obs;
  final activity = <PrototypeEvent>[].obs;
  final results = <PrototypeRipeness>[].obs;

  @override
  void onInit() {
    super.onInit();
    _resetScenarioData();
  }

  void selectScenario(DemoScenario value) {
    scenario.value = value;
    _resetScenarioData();
  }

  void _resetScenarioData() {
    actuatorStates.assignAll({
      ActuatorKind.pump: ActuatorState.stopped,
      ActuatorKind.fan: ActuatorState.running,
      ActuatorKind.roof: ActuatorState.closed,
      ActuatorKind.camera: ActuatorState.stopped,
    });
    latestCommands.clear();
    remainingIrrigationMinutes.value = 0;
    if (scenario.value == DemoScenario.commandPending) {
      latestCommands[ActuatorKind.pump] = ZoneCommand(
        zoneId: primaryZone.id,
        actuator: ActuatorKind.pump,
        requestedState: ActuatorState.running,
        progress: FarmerControlState.waiting,
        requestedAt: fixedNow,
        durationMinutes: 10,
      );
    }
    results.assignAll([
      PrototypeRipeness(
        id: 1,
        stage: scenario.value == DemoScenario.ripe
            ? 'ready_to_harvest'
            : scenario.value == DemoScenario.lowConfidence
                ? 'uncertain'
                : 'semi_ripe',
        confidence: scenario.value == DemoScenario.lowConfidence ? .54 : .91,
        capturedAt: fixedNow.subtract(const Duration(hours: 2)),
        cameraName: 'Camera GH-A-01',
        modelVersion: 'prototype-0.1',
      ),
    ]);
    activity.assignAll([
      PrototypeEvent(
        id: 1,
        type: 'irrigation',
        title: 'Irrigation completed',
        occurredAt: fixedNow.subtract(const Duration(hours: 3)),
        actor: 'Sokha (Owner)',
        device: 'Controller A1',
        zone: 'Greenhouse A',
        detail: '12 min • 0.18 m³ • 0.42 kWh',
      ),
      PrototypeEvent(
        id: 2,
        type: 'ripeness',
        title: 'Camera assessment saved',
        occurredAt: fixedNow.subtract(const Duration(hours: 5)),
        actor: 'LNTB prototype',
        device: 'Camera GH-A-01',
        zone: 'Greenhouse A',
        detail: 'Semi-ripe • 91% confidence',
      ),
    ]);
  }

  @override
  String get farmName => 'Cherry Tomato Demo Farm';

  FarmZone get primaryZone => const FarmZone(
        id: 'greenhouse-a',
        name: 'Greenhouse A',
        controllerName: 'Controller A1',
        cameraName: 'Camera GH-A-01',
      );

  List<FarmZone> get zones => [
        primaryZone,
        const FarmZone(
          id: 'field-b',
          name: 'Field B',
          controllerName: 'Controller B1',
          cameraName: 'Camera Field-B',
        ),
      ];

  @override
  bool get connected => scenario.value != DemoScenario.offline;

  @override
  bool get faulted => scenario.value == DemoScenario.safetyStop;

  @override
  DateTime get lastSync => fixedNow.subtract(
        scenario.value == DemoScenario.staleTelemetry
            ? const Duration(hours: 4)
            : const Duration(minutes: 2),
      );

  @override
  List<PrototypeReading> get readings {
    final stale = scenario.value == DemoScenario.staleTelemetry;
    final calibration = scenario.value == DemoScenario.calibrationRequired;
    final offline = scenario.value == DemoScenario.offline;
    DataQuality quality = offline
        ? DataQuality.unavailable
        : stale
            ? DataQuality.stale
            : calibration
                ? DataQuality.calibrationRequired
                : DataQuality.measured;
    PrototypeReading item(
      String code,
      double value,
      String unit,
      List<double> trend,
    ) =>
        PrototypeReading(
          code: code,
          value: offline ? null : value,
          unit: unit,
          recordedAt: lastSync,
          quality: quality,
          calibrated: !calibration,
          trend: trend,
        );
    return [
      item(
        'soil_moisture_1',
        scenario.value == DemoScenario.drySoil ? 21 : 54,
        '%',
        const [48, 51, 50, 53, 54],
      ),
      item('soil_moisture_2', 49, '%', const [45, 47, 48, 50, 49]),
      item('temperature', 28.4, '°C', const [26, 27, 28, 29, 28.4]),
      item('humidity', 72, '%', const [70, 69, 71, 73, 72]),
      item('light', 18200, 'lux', const [9200, 14000, 19000, 21000, 18200]),
    ];
  }

  @override
  Map<ActuatorKind, ActuatorState> get actuators => actuatorStates;

  bool get controlsBlocked =>
      !connected || faulted || readings.any((reading) => reading.blocksStart);

  String get blockingReason {
    if (!connected) return 'device_offline_reason';
    if (scenario.value == DemoScenario.staleTelemetry) {
      return 'data_too_old_reason';
    }
    if (scenario.value == DemoScenario.calibrationRequired) {
      return 'sensor_calibration_reason';
    }
    if (faulted) return 'device_fault_reason';
    return '';
  }

  @override
  Future<ActuatorState> run(ActuatorKind kind, bool activate) async {
    return runZoneCommand(
      primaryZone,
      kind,
      activate,
    );
  }

  Future<ActuatorState> runZoneCommand(
    FarmZone zone,
    ActuatorKind kind,
    bool activate, {
    int? durationMinutes,
  }) async {
    if (activate && controlsBlocked) {
      latestCommands[kind] = ZoneCommand(
        zoneId: zone.id,
        actuator: kind,
        requestedState: ActuatorState.failed,
        progress: FarmerControlState.failed,
        requestedAt: fixedNow,
        durationMinutes: durationMinutes,
      );
      return ActuatorState.failed;
    }
    final requested = !connected && !activate
        ? ActuatorState.queued
        : kind == ActuatorKind.roof
            ? (activate ? ActuatorState.open : ActuatorState.closed)
            : (activate ? ActuatorState.running : ActuatorState.stopped);
    latestCommands[kind] = ZoneCommand(
      zoneId: zone.id,
      actuator: kind,
      requestedState: requested,
      progress: requested == ActuatorState.queued
          ? FarmerControlState.waiting
          : FarmerControlState.waiting,
      requestedAt: fixedNow,
      durationMinutes: durationMinutes,
    );
    if (requested != ActuatorState.queued) {
      await Future<void>.delayed(const Duration(milliseconds: 450));
      actuatorStates[kind] = requested;
      latestCommands[kind] = latestCommands[kind]!.copyWith(
        progress:
            activate ? FarmerControlState.operating : FarmerControlState.ready,
      );
      if (kind == ActuatorKind.pump) {
        remainingIrrigationMinutes.value =
            activate ? (durationMinutes ?? 10) : 0;
      }
    }
    activity.insert(
      0,
      PrototypeEvent(
        id: activity.length + 10,
        type: 'command',
        title: '${kind.name}.${activate ? 'start' : 'stop'}',
        occurredAt: fixedNow,
        actor: scenario.value == DemoScenario.sharedUser
            ? 'Dara (Shared)'
            : 'Sokha (Owner)',
        device:
            kind == ActuatorKind.camera ? 'Camera GH-A-01' : 'Controller A1',
        zone: 'Greenhouse A',
        detail: requested.name,
        offlineReplay: requested == ActuatorState.queued,
      ),
    );
    return requested;
  }

  @override
  PrototypeUsage usageFor(String period) {
    final factor = switch (period) { 'week' => 7.0, 'month' => 30.0, _ => 1.0 };
    final missing = scenario.value == DemoScenario.metersUnavailable;
    return PrototypeUsage(
      waterM3: missing ? null : .42 * factor,
      energyKwh: missing ? null : 1.18 * factor,
      waterTariff: .35,
      energyTariff: .18,
      irrigationCount: (3 * factor).round(),
      irrigationMinutes: (34 * factor).round(),
      quality: missing ? DataQuality.unavailable : DataQuality.measured,
    );
  }

  @override
  List<PrototypeRipeness> get ripeness => results;

  @override
  void correctRipeness(int id, String stage) {
    final index = results.indexWhere((item) => item.id == id);
    if (index >= 0) results[index] = results[index].corrected(stage);
  }

  @override
  List<PrototypeEvent> get events => activity;

  @override
  void addNote(String title, String? detail) {
    activity.insert(
      0,
      PrototypeEvent(
        id: activity.length + 20,
        type: 'note',
        title: title,
        occurredAt: fixedNow,
        actor: 'Sokha (Owner)',
        device: 'Manual entry',
        zone: 'Greenhouse A',
        detail: detail,
      ),
    );
  }

  @override
  List<PrototypeEvent> get warnings => [
        if (scenario.value == DemoScenario.drySoil)
          PrototypeEvent(
            id: 100,
            type: 'warning',
            title: 'Root zone 1 is below prototype threshold',
            occurredAt: lastSync,
            actor: 'LNTB prototype',
            device: 'Controller A1',
            zone: 'Greenhouse A',
          ),
        if (!connected)
          PrototypeEvent(
            id: 101,
            type: 'warning',
            title: 'Controller A1 is offline',
            occurredAt: lastSync,
            actor: 'LNTB prototype',
            device: 'Controller A1',
            zone: 'Greenhouse A',
          ),
      ];
}
