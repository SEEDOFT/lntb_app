class FarmLog {
  const FarmLog({
    required this.id,
    required this.type,
    required this.title,
    required this.recordedAt,
    this.notes,
  });

  final int id;
  final String type;
  final String title;
  final String? notes;
  final DateTime recordedAt;

  factory FarmLog.fromJson(Map<String, dynamic> json) => FarmLog(
        id: json['id'] as int,
        type: (json['type'] as Map<String, dynamic>?)?['code'] as String? ??
            'note',
        title: json['title'] as String? ?? '',
        notes: json['notes'] as String?,
        recordedAt: DateTime.tryParse(json['recorded_at'] as String? ?? '') ??
            DateTime.now(),
      );
}
