class HarvestRecord {
  const HarvestRecord({
    required this.id,
    required this.quantity,
    required this.unit,
    required this.harvestedAt,
    this.grade,
    this.damagedQuantity,
  });

  final int id;
  final double quantity;
  final String unit;
  final DateTime harvestedAt;
  final String? grade;
  final double? damagedQuantity;

  factory HarvestRecord.fromJson(Map<String, dynamic> json) => HarvestRecord(
        id: json['id'] as int,
        quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
        unit: json['unit'] as String? ?? 'kg',
        harvestedAt: DateTime.tryParse(json['harvested_at'] as String? ?? '') ??
            DateTime.now(),
        grade: json['grade'] as String?,
        damagedQuantity: (json['damaged_quantity'] as num?)?.toDouble(),
      );
}
