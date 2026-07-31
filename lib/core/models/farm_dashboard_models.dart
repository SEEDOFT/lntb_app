import 'package:lntb_app/core/models/phase_one_models.dart';

class FarmSummary {
  const FarmSummary({
    required this.id,
    required this.name,
    required this.status,
    this.location,
    this.cropName,
  });

  final int id;
  final String name;
  final String status;
  final String? location;
  final String? cropName;

  factory FarmSummary.fromJson(Map<String, dynamic> json) {
    final status = json['status'] as Map<String, dynamic>?;
    final cycle = json['current_crop_cycle'] as Map<String, dynamic>?;

    return FarmSummary(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      status: status?['code'] as String? ?? 'inactive',
      location: json['location'] as String?,
      cropName: cycle?['crop_name'] as String?,
    );
  }
}

class DashboardMetric {
  const DashboardMetric({
    required this.code,
    required this.value,
    required this.unit,
    required this.status,
    required this.recordedAt,
    required this.deviceId,
    required this.deviceName,
  });

  final String code;
  final double value;
  final String unit;
  final String status;
  final DateTime? recordedAt;
  final int deviceId;
  final String deviceName;

  factory DashboardMetric.fromJson(Map<String, dynamic> json) {
    final device = json['device'] as Map<String, dynamic>? ?? const {};

    return DashboardMetric(
      code: json['code'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String? ?? '',
      status: json['status'] as String? ?? 'unknown',
      recordedAt: DateTime.tryParse(json['recorded_at'] as String? ?? ''),
      deviceId: device['id'] as int? ?? 0,
      deviceName: device['name'] as String? ?? '',
    );
  }
}

class DashboardWarning {
  const DashboardWarning({
    required this.code,
    required this.message,
    this.recordedAt,
  });

  final String code;
  final String message;
  final DateTime? recordedAt;

  factory DashboardWarning.fromJson(Map<String, dynamic> json) =>
      DashboardWarning(
        code: json['code'] as String? ?? '',
        message: json['message'] as String? ?? '',
        recordedAt: DateTime.tryParse(json['recorded_at'] as String? ?? ''),
      );
}

class DashboardUsage {
  const DashboardUsage({
    required this.waterCubicMeters,
    required this.electricityKwh,
    required this.totalCostUsd,
    this.recordedOn,
  });

  final double waterCubicMeters;
  final double electricityKwh;
  final double totalCostUsd;
  final DateTime? recordedOn;

  factory DashboardUsage.fromJson(Map<String, dynamic> json) => DashboardUsage(
        waterCubicMeters: (json['water_cubic_meters'] as num?)?.toDouble() ?? 0,
        electricityKwh: (json['electricity_kwh'] as num?)?.toDouble() ?? 0,
        totalCostUsd: (json['total_cost_usd'] as num?)?.toDouble() ?? 0,
        recordedOn: DateTime.tryParse(json['recorded_on'] as String? ?? ''),
      );
}

class AssistantSummary {
  const AssistantSummary({
    required this.question,
    required this.answer,
    this.createdAt,
  });

  final String question;
  final String answer;
  final DateTime? createdAt;

  factory AssistantSummary.fromJson(Map<String, dynamic> json) =>
      AssistantSummary(
        question: json['question'] as String? ?? '',
        answer: json['answer'] as String? ?? '',
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
      );
}

class FarmDashboard {
  const FarmDashboard({
    required this.farm,
    required this.metrics,
    required this.devices,
    required this.activity,
    required this.warnings,
    required this.onlineDeviceCount,
    this.usage,
    this.assistant,
  });

  final FarmSummary farm;
  final List<DashboardMetric> metrics;
  final List<DeviceModel> devices;
  final List<ControlRecord> activity;
  final List<DashboardWarning> warnings;
  final int onlineDeviceCount;
  final DashboardUsage? usage;
  final AssistantSummary? assistant;

  factory FarmDashboard.fromJson(Map<String, dynamic> json) => FarmDashboard(
        farm: FarmSummary.fromJson(json['farm'] as Map<String, dynamic>),
        metrics: (json['metrics'] as List? ?? const [])
            .map(
              (item) => DashboardMetric.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
        devices: (json['devices'] as List? ?? const [])
            .map((item) => DeviceModel.fromJson(item as Map<String, dynamic>))
            .toList(),
        activity: (json['activity'] as List? ?? const [])
            .map((item) => ControlRecord.fromJson(item as Map<String, dynamic>))
            .toList(),
        warnings: (json['warnings'] as List? ?? const [])
            .map(
              (item) => DashboardWarning.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
        onlineDeviceCount: json['online_device_count'] as int? ?? 0,
        usage: json['usage'] is Map<String, dynamic>
            ? DashboardUsage.fromJson(json['usage'] as Map<String, dynamic>)
            : null,
        assistant: json['assistant'] is Map<String, dynamic>
            ? AssistantSummary.fromJson(
                json['assistant'] as Map<String, dynamic>,
              )
            : null,
      );

  DashboardMetric? metric(String code) {
    for (final metric in metrics) {
      if (metric.code == code) return metric;
    }
    return null;
  }
}
