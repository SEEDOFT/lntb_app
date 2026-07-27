class RipenessResult {
  const RipenessResult({
    required this.id,
    required this.stage,
    required this.confidence,
    required this.capturedAt,
    this.imageUrl,
    this.modelVersion,
    this.recommendation,
  });

  final int id;
  final String stage;
  final double confidence;
  final DateTime capturedAt;
  final String? imageUrl;
  final String? modelVersion;
  final String? recommendation;

  factory RipenessResult.fromJson(Map<String, dynamic> json) => RipenessResult(
        id: json['id'] as int,
        stage: (json['stage'] as Map<String, dynamic>?)?['code'] as String? ??
            'unknown',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
        capturedAt: DateTime.tryParse(json['captured_at'] as String? ?? '') ??
            DateTime.now(),
        imageUrl: json['image_url'] as String?,
        modelVersion: json['model_version'] as String?,
        recommendation: json['recommendation'] as String?,
      );
}
