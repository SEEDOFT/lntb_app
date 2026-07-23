class Farm {
  const Farm({
    required this.id,
    required this.name,
    required this.status,
    this.location,
    this.currentCrop,
  });

  final int id;
  final String name;
  final String status;
  final String? location;
  final String? currentCrop;

  factory Farm.fromJson(Map<String, dynamic> json) => Farm(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        status: (json['status'] as Map<String, dynamic>?)?['code'] as String? ??
            'inactive',
        location: json['location'] as String?,
        currentCrop: (json['current_crop_cycle']
            as Map<String, dynamic>?)?['crop_name'] as String?,
      );
}

class SensorMetric {
  const SensorMetric({
    required this.code,
    required this.value,
    required this.unit,
    required this.status,
    this.recordedAt,
  });

  final String code;
  final double value;
  final String unit;
  final String status;
  final DateTime? recordedAt;

  factory SensorMetric.fromJson(Map<String, dynamic> json) => SensorMetric(
        code: json['code'] as String? ?? '',
        value: (json['value'] as num?)?.toDouble() ?? 0,
        unit: json['unit'] as String? ?? '',
        status: json['status'] as String? ?? 'unknown',
        recordedAt: DateTime.tryParse(json['recorded_at'] as String? ?? ''),
      );
}

class FarmDashboard {
  const FarmDashboard({
    required this.farm,
    required this.metrics,
    required this.openTaskCount,
    required this.onlineDeviceCount,
    this.latestAlert,
  });

  final Farm farm;
  final List<SensorMetric> metrics;
  final int openTaskCount;
  final int onlineDeviceCount;
  final String? latestAlert;

  factory FarmDashboard.fromJson(Map<String, dynamic> json) => FarmDashboard(
        farm: Farm.fromJson(json['farm'] as Map<String, dynamic>),
        metrics: ((json['metrics'] as List?) ?? const [])
            .map(
              (item) => SensorMetric.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
        openTaskCount: json['open_task_count'] as int? ?? 0,
        onlineDeviceCount: json['online_device_count'] as int? ?? 0,
        latestAlert: json['latest_alert'] as String?,
      );
}
