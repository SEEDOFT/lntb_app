enum DataQuality {
  measured,
  estimated,
  stale,
  unavailable,
  calibrationRequired
}

enum DemoScenario {
  healthy,
  drySoil,
  offline,
  staleTelemetry,
  calibrationRequired,
  commandPending,
  partialFailure,
  safetyStop,
  metersUnavailable,
  ripe,
  lowConfidence,
  sharedUser,
}

enum ActuatorKind { pump, fan, roof, camera }

enum ActuatorState { stopped, running, open, closed, pending, queued, failed }

enum FarmerControlState {
  ready,
  operating,
  waiting,
  offline,
  unsafe,
  failed,
}

class FarmZone {
  const FarmZone({
    required this.id,
    required this.name,
    required this.controllerName,
    required this.cameraName,
  });

  final String id;
  final String name;
  final String controllerName;
  final String cameraName;
}

class ZoneCommand {
  const ZoneCommand({
    required this.zoneId,
    required this.actuator,
    required this.requestedState,
    required this.progress,
    required this.requestedAt,
    this.durationMinutes,
  });

  final String zoneId;
  final ActuatorKind actuator;
  final ActuatorState requestedState;
  final FarmerControlState progress;
  final DateTime requestedAt;
  final int? durationMinutes;

  ZoneCommand copyWith({
    FarmerControlState? progress,
  }) =>
      ZoneCommand(
        zoneId: zoneId,
        actuator: actuator,
        requestedState: requestedState,
        progress: progress ?? this.progress,
        requestedAt: requestedAt,
        durationMinutes: durationMinutes,
      );
}

class PrototypeReading {
  const PrototypeReading({
    required this.code,
    required this.value,
    required this.unit,
    required this.recordedAt,
    this.quality = DataQuality.measured,
    this.calibrated = true,
    this.trend = const [],
  });

  final String code;
  final double? value;
  final String unit;
  final DateTime recordedAt;
  final DataQuality quality;
  final bool calibrated;
  final List<double> trend;

  bool get blocksStart =>
      quality == DataQuality.stale ||
      quality == DataQuality.unavailable ||
      quality == DataQuality.calibrationRequired ||
      !calibrated;
}

class PrototypeUsage {
  const PrototypeUsage({
    required this.waterM3,
    required this.energyKwh,
    required this.waterTariff,
    required this.energyTariff,
    required this.irrigationCount,
    required this.irrigationMinutes,
    this.quality = DataQuality.measured,
  });

  final double? waterM3;
  final double? energyKwh;
  final double waterTariff;
  final double energyTariff;
  final int irrigationCount;
  final int irrigationMinutes;
  final DataQuality quality;

  double? get estimatedCost => waterM3 == null || energyKwh == null
      ? null
      : waterM3! * waterTariff + energyKwh! * energyTariff;
}

class PrototypeRipeness {
  const PrototypeRipeness({
    required this.id,
    required this.stage,
    required this.confidence,
    required this.capturedAt,
    required this.cameraName,
    required this.modelVersion,
    this.farmerCorrection,
  });

  final int id;
  final String stage;
  final double confidence;
  final DateTime capturedAt;
  final String cameraName;
  final String modelVersion;
  final String? farmerCorrection;

  PrototypeRipeness corrected(String stage) => PrototypeRipeness(
        id: id,
        stage: this.stage,
        confidence: confidence,
        capturedAt: capturedAt,
        cameraName: cameraName,
        modelVersion: modelVersion,
        farmerCorrection: stage,
      );
}

class PrototypeEvent {
  const PrototypeEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.occurredAt,
    required this.actor,
    required this.device,
    required this.zone,
    this.detail,
    this.offlineReplay = false,
  });

  final int id;
  final String type;
  final String title;
  final DateTime occurredAt;
  final String actor;
  final String device;
  final String zone;
  final String? detail;
  final bool offlineReplay;
}
