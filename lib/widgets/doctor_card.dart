import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carepilot/models/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;

  const DoctorCard({super.key, required this.doctor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(doctor.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor.name, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 4),
                  Text(doctor.specialty, style: GoogleFonts.inter(fontSize: 14, color: Theme.of(context).colorScheme.primary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${doctor.rating}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 12),
                      Text('${doctor.experience} years', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(doctor.availability, style: GoogleFonts.inter(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
