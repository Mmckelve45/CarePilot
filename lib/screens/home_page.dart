import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carepilot/models/user_model.dart';
import 'package:carepilot/models/appointment_model.dart';
import 'package:carepilot/models/doctor_model.dart';
import 'package:carepilot/services/user_service.dart';
import 'package:carepilot/services/appointment_service.dart';
import 'package:carepilot/services/doctor_service.dart';
import 'package:carepilot/screens/doctors_page.dart';
import 'package:carepilot/screens/symptom_checker_page.dart';
import 'package:carepilot/screens/profile_page.dart';
import 'package:carepilot/screens/appointment_history_page.dart';
import 'package:carepilot/widgets/appointment_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserService _userService = UserService();
  final AppointmentService _appointmentService = AppointmentService();
  final DoctorService _doctorService = DoctorService();

  UserModel? _currentUser;
  List<AppointmentModel> _upcomingAppointments = [];
  Map<String, DoctorModel> _doctorsMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _userService.getCurrentUser();
    final appointments = user != null ? await _appointmentService.getUpcomingAppointments(user.id) : <AppointmentModel>[];
    final doctors = await _doctorService.getAllDoctors();
    final doctorsMap = {for (var d in doctors) d.id: d};

    setState(() {
      _currentUser = user;
      _upcomingAppointments = appointments;
      _doctorsMap = doctorsMap;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hello,', style: GoogleFonts.inter(fontSize: 16, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(_currentUser?.name ?? 'Guest', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('How are you feeling today?', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: QuickActionCard(icon: Icons.search, title: 'Find Doctors', color: const Color(0xFF00ACC1), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorsPage())))),
                        const SizedBox(width: 16),
                        Expanded(child: QuickActionCard(icon: Icons.health_and_safety, title: 'Symptom Checker', color: const Color(0xFF29B6F6), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SymptomCheckerPage())))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: QuickActionCard(icon: Icons.history, title: 'My Appointments', color: const Color(0xFFFF6B6B), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentHistoryPage())))),
                        const SizedBox(width: 16),
                        Expanded(child: QuickActionCard(icon: Icons.medical_services, title: 'Health Records', color: const Color(0xFF4CAF50), onTap: () {})),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Upcoming Appointments', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
                        if (_upcomingAppointments.isNotEmpty)
                          TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentHistoryPage())),
                            child: Text('View All', style: GoogleFonts.inter(fontSize: 14, color: Theme.of(context).colorScheme.primary)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _upcomingAppointments.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey.shade300),
                                  const SizedBox(height: 16),
                                  Text('No upcoming appointments', style: GoogleFonts.inter(fontSize: 16, color: Colors.grey)),
                                  const SizedBox(height: 8),
                                  Text('Book a consultation with our doctors', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _upcomingAppointments.length,
                            itemBuilder: (context, index) {
                              final appointment = _upcomingAppointments[index];
                              final doctor = _doctorsMap[appointment.doctorId];
                              if (doctor == null) return const SizedBox.shrink();
                              return AppointmentCard(appointment: appointment, doctor: doctor);
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const QuickActionCard({super.key, required this.icon, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}
