import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carepilot/models/symptom_model.dart';

class SymptomService {
  static const String _storageKey = 'symptoms';

  Future<List<SymptomModel>> getAllSymptoms(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final symptomsJson = prefs.getString(_storageKey);
    if (symptomsJson != null) {
      final List<dynamic> decoded = json.decode(symptomsJson);
      return decoded
          .map((s) => SymptomModel.fromJson(s))
          .where((s) => s.userId == userId)
          .toList();
    }
    return [];
  }

  Future<void> createSymptom(SymptomModel symptom) async {
    final prefs = await SharedPreferences.getInstance();
    final symptomsJson = prefs.getString(_storageKey);
    List<SymptomModel> symptoms = [];
    
    if (symptomsJson != null) {
      final List<dynamic> decoded = json.decode(symptomsJson);
      symptoms = decoded.map((s) => SymptomModel.fromJson(s)).toList();
    }
    
    symptoms.add(symptom);
    final updatedJson = symptoms.map((s) => s.toJson()).toList();
    await prefs.setString(_storageKey, json.encode(updatedJson));
  }

  List<String> getCommonSymptoms() => [
    'Fever',
    'Cough',
    'Headache',
    'Fatigue',
    'Nausea',
    'Sore Throat',
    'Body Aches',
    'Shortness of Breath',
    'Chest Pain',
    'Dizziness',
    'Runny Nose',
    'Loss of Appetite',
  ];
}
