class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime? dateOfBirth;
  final String gender;
  final String? bloodType;
  final List<String> allergies;
  final String? medicalHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    required this.gender,
    this.bloodType,
    this.allergies = const [],
    this.medicalHistory,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'gender': gender,
    'bloodType': bloodType,
    'allergies': allergies,
    'medicalHistory': medicalHistory,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth'] as String) : null,
    gender: json['gender'] as String,
    bloodType: json['bloodType'] as String?,
    allergies: (json['allergies'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    medicalHistory: json['medicalHistory'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodType,
    List<String>? allergies,
    String? medicalHistory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gender: gender ?? this.gender,
    bloodType: bloodType ?? this.bloodType,
    allergies: allergies ?? this.allergies,
    medicalHistory: medicalHistory ?? this.medicalHistory,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
