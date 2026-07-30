import 'package:lntb_app/core/models/prototype/prototype_models.dart';

abstract interface class DashboardRepository {
  List<PrototypeReading> get readings;
  bool get connected;
  String get farmName;
}

abstract interface class TelemetryRepository {
  List<PrototypeReading> get readings;
}

abstract interface class IrrigationRepository {
  Map<ActuatorKind, ActuatorState> get actuators;
  Future<ActuatorState> run(ActuatorKind kind, bool activate);
}

abstract interface class UsageRepository {
  PrototypeUsage usageFor(String period);
}

abstract interface class RipenessRepository {
  List<PrototypeRipeness> get ripeness;
  void correctRipeness(int id, String stage);
}

abstract interface class FarmLogRepository {
  List<PrototypeEvent> get events;
  void addNote(String title, String? detail);
}

abstract interface class NotificationFeedRepository {
  List<PrototypeEvent> get warnings;
}

abstract interface class DeviceHealthRepository {
  bool get connected;
  bool get faulted;
  DateTime get lastSync;
}
