import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carepilot/models/appointment_model.dart';

class AppointmentService {
  static const String _storageKey = 'appointments';

  Future<void> _initializeSampleData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_storageKey)) {
      final sampleAppointments = [
        AppointmentModel(
          id: 'appt_001',
          patientId: 'user_001',
          doctorId: 'doc_001',
          dateTime: DateTime.now().add(const Duration(days: 2, hours: 10)),
          status: 'Scheduled',
          type: 'Video Call',
          symptoms: 'Persistent cough and mild fever',
          notes: 'First consultation',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        AppointmentModel(
          id: 'appt_002',
          patientId: 'user_001',
          doctorId: 'doc_002',
          dateTime: DateTime.now().subtract(const Duration(days: 15)),
          status: 'Completed',
          type: 'Video Call',
          symptoms: 'Chest pain and shortness of breath',
          notes: 'Follow-up recommended',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          updatedAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ];
      final appointmentsJson = sampleAppointments.map((a) => a.toJson()).toList();
      await prefs.setString(_storageKey, json.encode(appointmentsJson));
    }
  }

  Future<List<AppointmentModel>> getAllAppointments() async {
    await _initializeSampleData();
    final prefs = await SharedPreferences.getInstance();
    final appointmentsJson = prefs.getString(_storageKey);
    if (appointmentsJson != null) {
      final List<dynamic> decoded = json.decode(appointmentsJson);
      return decoded.map((a) => AppointmentModel.fromJson(a)).toList();
    }
    return [];
  }

  Future<List<AppointmentModel>> getUpcomingAppointments(String userId) async {
    final appointments = await getAllAppointments();
    return appointments
        .where((a) => a.patientId == userId && a.dateTime.isAfter(DateTime.now()) && a.status == 'Scheduled')
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  Future<List<AppointmentModel>> getPastAppointments(String userId) async {
    final appointments = await getAllAppointments();
    return appointments
        .where((a) => a.patientId == userId && (a.dateTime.isBefore(DateTime.now()) || a.status == 'Completed'))
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<void> createAppointment(AppointmentModel appointment) async {
    final appointments = await getAllAppointments();
    appointments.add(appointment);
    final prefs = await SharedPreferences.getInstance();
    final appointmentsJson = appointments.map((a) => a.toJson()).toList();
    await prefs.setString(_storageKey, json.encode(appointmentsJson));
  }

  Future<void> updateAppointment(AppointmentModel appointment) async {
    final appointments = await getAllAppointments();
    final index = appointments.indexWhere((a) => a.id == appointment.id);
    if (index != -1) {
      appointments[index] = appointment.copyWith(updatedAt: DateTime.now());
      final prefs = await SharedPreferences.getInstance();
      final appointmentsJson = appointments.map((a) => a.toJson()).toList();
      await prefs.setString(_storageKey, json.encode(appointmentsJson));
    }
  }
}
