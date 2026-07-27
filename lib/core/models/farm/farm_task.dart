class FarmTask {
  const FarmTask({
    required this.id,
    required this.title,
    required this.status,
    required this.source,
    this.description,
    this.dueAt,
  });

  final int id;
  final String title;
  final String status;
  final String source;
  final String? description;
  final DateTime? dueAt;

  factory FarmTask.fromJson(Map<String, dynamic> json) => FarmTask(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        status: (json['status'] as Map<String, dynamic>?)?['code'] as String? ??
            'open',
        source: (json['source'] as Map<String, dynamic>?)?['code'] as String? ??
            'manual',
        description: json['description'] as String?,
        dueAt: DateTime.tryParse(json['due_at'] as String? ?? ''),
      );
}
