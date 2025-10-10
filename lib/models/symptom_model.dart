class SymptomModel {
  final String id;
  final String userId;
  final List<String> symptoms;
  final String severity;
  final String duration;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  SymptomModel({
    required this.id,
    required this.userId,
    required this.symptoms,
    required this.severity,
    required this.duration,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'symptoms': symptoms,
    'severity': severity,
    'duration': duration,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory SymptomModel.fromJson(Map<String, dynamic> json) => SymptomModel(
    id: json['id'] as String,
    userId: json['userId'] as String,
    symptoms: (json['symptoms'] as List<dynamic>).map((e) => e as String).toList(),
    severity: json['severity'] as String,
    duration: json['duration'] as String,
    notes: json['notes'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  SymptomModel copyWith({
    String? id,
    String? userId,
    List<String>? symptoms,
    String? severity,
    String? duration,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SymptomModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    symptoms: symptoms ?? this.symptoms,
    severity: severity ?? this.severity,
    duration: duration ?? this.duration,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
