import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:carepilot/models/doctor_model.dart';
import 'package:carepilot/models/appointment_model.dart';
import 'package:carepilot/models/user_model.dart';
import 'package:carepilot/services/appointment_service.dart';
import 'package:carepilot/services/user_service.dart';
import 'package:carepilot/widgets/custom_button.dart';

class BookAppointmentPage extends StatefulWidget {
  final DoctorModel doctor;

  const BookAppointmentPage({super.key, required this.doctor});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final AppointmentService _appointmentService = AppointmentService();
  final UserService _userService = UserService();
  final TextEditingController _symptomsController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  String _selectedType = 'Video Call';
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _userService.getCurrentUser();
    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
  }

  Future<void> _bookAppointment() async {
    if (_symptomsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your symptoms')),
      );
      return;
    }

    if (_currentUser == null) return;

    final appointmentDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final appointment = AppointmentModel(
      id: 'appt_${DateTime.now().millisecondsSinceEpoch}',
      patientId: _currentUser!.id,
      doctorId: widget.doctor.id,
      dateTime: appointmentDateTime,
      status: 'Scheduled',
      type: _selectedType,
      symptoms: _symptomsController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _appointmentService.createAppointment(appointment);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment booked successfully!')),
      );
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Book Appointment', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(widget.doctor.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.doctor.name, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(widget.doctor.specialty, style: GoogleFonts.inter(fontSize: 14, color: Theme.of(context).colorScheme.primary)),
                        const SizedBox(height: 8),
                        Text('Fee: \$${widget.doctor.consultationFee.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Date', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (date != null) setState(() => _selectedDate = date);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Text(DateFormat('EEEE, MMM dd, yyyy').format(_selectedDate), style: GoogleFonts.inter(fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Time', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final time = await showTimePicker(context: context, initialTime: _selectedTime);
                      if (time != null) setState(() => _selectedTime = time);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Text(_selectedTime.format(context), style: GoogleFonts.inter(fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Consultation Type', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ConsultationTypeOption(
                          icon: Icons.videocam,
                          label: 'Video Call',
                          isSelected: _selectedType == 'Video Call',
                          onTap: () => setState(() => _selectedType = 'Video Call'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ConsultationTypeOption(
                          icon: Icons.phone,
                          label: 'Phone Call',
                          isSelected: _selectedType == 'Phone Call',
                          onTap: () => setState(() => _selectedType = 'Phone Call'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Describe Your Symptoms', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _symptomsController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Please describe what you are experiencing...',
                      hintStyle: GoogleFonts.inter(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                text: 'Confirm Booking',
                onPressed: _bookAppointment,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class ConsultationTypeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ConsultationTypeOption({super.key, required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey, size: 32),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey)),
          ],
        ),
      ),
    );
  }
}
