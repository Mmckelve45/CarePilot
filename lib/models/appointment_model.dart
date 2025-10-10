class AppointmentModel {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime dateTime;
  final String status;
  final String type;
  final String symptoms;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.dateTime,
    required this.status,
    required this.type,
    required this.symptoms,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'patientId': patientId,
    'doctorId': doctorId,
    'dateTime': dateTime.toIso8601String(),
    'status': status,
    'type': type,
    'symptoms': symptoms,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
    id: json['id'] as String,
    patientId: json['patientId'] as String,
    doctorId: json['doctorId'] as String,
    dateTime: DateTime.parse(json['dateTime'] as String),
    status: json['status'] as String,
    type: json['type'] as String,
    symptoms: json['symptoms'] as String,
    notes: json['notes'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    DateTime? dateTime,
    String? status,
    String? type,
    String? symptoms,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AppointmentModel(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    doctorId: doctorId ?? this.doctorId,
    dateTime: dateTime ?? this.dateTime,
    status: status ?? this.status,
    type: type ?? this.type,
    symptoms: symptoms ?? this.symptoms,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
