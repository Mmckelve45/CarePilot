import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carepilot/models/user_model.dart';

class UserService {
  static const String _storageKey = 'current_user';

  Future<void> _initializeSampleData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_storageKey)) {
      final sampleUser = UserModel(
        id: 'user_001',
        name: 'Sarah Johnson',
        email: 'sarah.johnson@email.com',
        phone: '+1 (555) 123-4567',
        dateOfBirth: DateTime(1990, 5, 15),
        gender: 'Female',
        bloodType: 'O+',
        allergies: ['Penicillin', 'Pollen'],
        medicalHistory: 'No major medical conditions. Regular checkups.',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await prefs.setString(_storageKey, json.encode(sampleUser.toJson()));
    }
  }

  Future<UserModel?> getCurrentUser() async {
    await _initializeSampleData();
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_storageKey);
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final updatedUser = user.copyWith(updatedAt: DateTime.now());
    await prefs.setString(_storageKey, json.encode(updatedUser.toJson()));
  }
}
