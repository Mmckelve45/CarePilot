import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carepilot/models/user_model.dart';
import 'package:carepilot/models/appointment_model.dart';
import 'package:carepilot/models/doctor_model.dart';
import 'package:carepilot/services/user_service.dart';
import 'package:carepilot/services/appointment_service.dart';
import 'package:carepilot/services/doctor_service.dart';
import 'package:carepilot/widgets/appointment_card.dart';

class AppointmentHistoryPage extends StatefulWidget {
  const AppointmentHistoryPage({super.key});

  @override
  State<AppointmentHistoryPage> createState() => _AppointmentHistoryPageState();
}

class _AppointmentHistoryPageState extends State<AppointmentHistoryPage> with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  final AppointmentService _appointmentService = AppointmentService();
  final DoctorService _doctorService = DoctorService();

  late TabController _tabController;
  UserModel? _currentUser;
  List<AppointmentModel> _upcomingAppointments = [];
  List<AppointmentModel> _pastAppointments = [];
  Map<String, DoctorModel> _doctorsMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final user = await _userService.getCurrentUser();
    if (user != null) {
      final upcoming = await _appointmentService.getUpcomingAppointments(user.id);
      final past = await _appointmentService.getPastAppointments(user.id);
      final doctors = await _doctorService.getAllDoctors();
      final doctorsMap = {for (var d in doctors) d.id: d};

      setState(() {
        _currentUser = user;
        _upcomingAppointments = upcoming;
        _pastAppointments = past;
        _doctorsMap = doctorsMap;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('My Appointments', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentList(_upcomingAppointments, 'No upcoming appointments'),
                _buildAppointmentList(_pastAppointments, 'No past appointments'),
              ],
            ),
    );
  }

  Widget _buildAppointmentList(List<AppointmentModel> appointments, String emptyMessage) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(emptyMessage, style: GoogleFonts.inter(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        final doctor = _doctorsMap[appointment.doctorId];
        if (doctor == null) return const SizedBox.shrink();
        return AppointmentCard(appointment: appointment, doctor: doctor);
      },
    );
  }
}
