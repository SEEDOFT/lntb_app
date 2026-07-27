class UsageSummary {
  const UsageSummary({
    required this.waterCubicMeters,
    required this.electricityKwh,
    required this.totalCostUsd,
    this.recordedOn,
  });

  final double waterCubicMeters;
  final double electricityKwh;
  final double totalCostUsd;
  final DateTime? recordedOn;

  factory UsageSummary.fromJson(Map<String, dynamic> json) => UsageSummary(
        waterCubicMeters: (json['water_cubic_meters'] as num?)?.toDouble() ?? 0,
        electricityKwh: (json['electricity_kwh'] as num?)?.toDouble() ?? 0,
        totalCostUsd: (json['total_cost_usd'] as num?)?.toDouble() ?? 0,
        recordedOn: DateTime.tryParse(json['recorded_on'] as String? ?? ''),
      );
}
