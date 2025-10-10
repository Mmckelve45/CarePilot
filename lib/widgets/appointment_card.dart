import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:carepilot/models/appointment_model.dart';
import 'package:carepilot/models/doctor_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final DoctorModel doctor;
  final VoidCallback? onTap;

  const AppointmentCard({super.key, required this.appointment, required this.doctor, this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(doctor.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.name, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(doctor.specialty, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: appointment.status == 'Scheduled' ? Colors.blue.shade50 : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    appointment.status,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: appointment.status == 'Scheduled' ? Colors.blue.shade700 : Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(dateFormat.format(appointment.dateTime), style: GoogleFonts.inter(fontSize: 14)),
                const SizedBox(width: 24),
                Icon(Icons.access_time, size: 16, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(timeFormat.format(appointment.dateTime), style: GoogleFonts.inter(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.videocam, size: 16, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(appointment.type, style: GoogleFonts.inter(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
