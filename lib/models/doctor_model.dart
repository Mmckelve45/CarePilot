class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final int experience;
  final double rating;
  final String availability;
  final String imageUrl;
  final String about;
  final double consultationFee;
  final DateTime createdAt;
  final DateTime updatedAt;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.rating,
    required this.availability,
    required this.imageUrl,
    required this.about,
    required this.consultationFee,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialty': specialty,
    'experience': experience,
    'rating': rating,
    'availability': availability,
    'imageUrl': imageUrl,
    'about': about,
    'consultationFee': consultationFee,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
    id: json['id'] as String,
    name: json['name'] as String,
    specialty: json['specialty'] as String,
    experience: json['experience'] as int,
    rating: (json['rating'] as num).toDouble(),
    availability: json['availability'] as String,
    imageUrl: json['imageUrl'] as String,
    about: json['about'] as String,
    consultationFee: (json['consultationFee'] as num).toDouble(),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  DoctorModel copyWith({
    String? id,
    String? name,
    String? specialty,
    int? experience,
    double? rating,
    String? availability,
    String? imageUrl,
    String? about,
    double? consultationFee,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DoctorModel(
    id: id ?? this.id,
    name: name ?? this.name,
    specialty: specialty ?? this.specialty,
    experience: experience ?? this.experience,
    rating: rating ?? this.rating,
    availability: availability ?? this.availability,
    imageUrl: imageUrl ?? this.imageUrl,
    about: about ?? this.about,
    consultationFee: consultationFee ?? this.consultationFee,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
