import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carepilot/models/doctor_model.dart';

class DoctorService {
  static const String _storageKey = 'doctors';

  final List<DoctorModel> _sampleDoctors = [
    DoctorModel(
      id: 'doc_001',
      name: 'Dr. Michael Chen',
      specialty: 'General Practitioner',
      experience: 12,
      rating: 4.8,
      availability: 'Available Today',
      imageUrl: 'assets/images/Doctor_Portrait_Professional_null_1760110941853.jpg',
      about: 'Board-certified physician with over 12 years of experience in general medicine. Specialized in preventive care and chronic disease management.',
      consultationFee: 75.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    DoctorModel(
      id: 'doc_002',
      name: 'Dr. Emily Rodriguez',
      specialty: 'Cardiologist',
      experience: 15,
      rating: 4.9,
      availability: 'Available Tomorrow',
      imageUrl: 'assets/images/Medical_Professional_Female_null_1760110942596.jpg',
      about: 'Expert cardiologist specializing in heart disease prevention and treatment. Published researcher in cardiovascular health.',
      consultationFee: 120.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    DoctorModel(
      id: 'doc_003',
      name: 'Dr. James Thompson',
      specialty: 'Dermatologist',
      experience: 10,
      rating: 4.7,
      availability: 'Available Today',
      imageUrl: 'assets/images/Cardiologist_Doctor_null_1760110943244.jpg',
      about: 'Skilled dermatologist with expertise in both medical and cosmetic dermatology. Passionate about skin health education.',
      consultationFee: 95.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    DoctorModel(
      id: 'doc_004',
      name: 'Dr. Priya Patel',
      specialty: 'Pediatrician',
      experience: 8,
      rating: 4.9,
      availability: 'Available Today',
      imageUrl: 'assets/images/Dermatologist_Professional_null_1760110944085.jpg',
      about: 'Compassionate pediatrician dedicated to child health and development. Experience with newborns to adolescents.',
      consultationFee: 80.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    DoctorModel(
      id: 'doc_005',
      name: 'Dr. David Kim',
      specialty: 'Psychiatrist',
      experience: 14,
      rating: 4.8,
      availability: 'Available Tomorrow',
      imageUrl: 'assets/images/Pediatrician_Doctor_null_1760110944908.jpg',
      about: 'Licensed psychiatrist specializing in anxiety, depression, and stress management. Advocate for mental health awareness.',
      consultationFee: 110.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    DoctorModel(
      id: 'doc_006',
      name: 'Dr. Lisa Wang',
      specialty: 'Endocrinologist',
      experience: 11,
      rating: 4.7,
      availability: 'Available Today',
      imageUrl: 'assets/images/Psychiatrist_Professional_null_1760110945793.jpg',
      about: 'Endocrinology specialist focusing on diabetes, thyroid disorders, and hormonal imbalances. Patient-centered care approach.',
      consultationFee: 100.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  Future<void> _initializeSampleData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_storageKey)) {
      final doctorsJson = _sampleDoctors.map((d) => d.toJson()).toList();
      await prefs.setString(_storageKey, json.encode(doctorsJson));
    }
  }

  Future<List<DoctorModel>> getAllDoctors() async {
    await _initializeSampleData();
    final prefs = await SharedPreferences.getInstance();
    final doctorsJson = prefs.getString(_storageKey);
    if (doctorsJson != null) {
      final List<dynamic> decoded = json.decode(doctorsJson);
      return decoded.map((d) => DoctorModel.fromJson(d)).toList();
    }
    return [];
  }

  Future<DoctorModel?> getDoctorById(String id) async {
    final doctors = await getAllDoctors();
    try {
      return doctors.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<DoctorModel>> searchDoctors(String query) async {
    final doctors = await getAllDoctors();
    if (query.isEmpty) return doctors;
    return doctors.where((d) =>
      d.name.toLowerCase().contains(query.toLowerCase()) ||
      d.specialty.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
