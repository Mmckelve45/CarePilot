import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carepilot/models/doctor_model.dart';
import 'package:carepilot/screens/book_appointment_page.dart';
import 'package:carepilot/widgets/custom_button.dart';

class DoctorDetailPage extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(doctor.imageUrl, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doctor.name, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(doctor.specialty, style: GoogleFonts.inter(fontSize: 16, color: Theme.of(context).colorScheme.primary)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 24),
                              const SizedBox(height: 4),
                              Text('${doctor.rating}', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: InfoTile(icon: Icons.work_outline, title: 'Experience', value: '${doctor.experience} Years')),
                        const SizedBox(width: 16),
                        Expanded(child: InfoTile(icon: Icons.people_outline, title: 'Patients', value: '2,500+')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: InfoTile(icon: Icons.access_time, title: 'Availability', value: doctor.availability)),
                        const SizedBox(width: 16),
                        Expanded(child: InfoTile(icon: Icons.attach_money, title: 'Fee', value: '\$${doctor.consultationFee.toStringAsFixed(0)}')),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text('About', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(doctor.about, style: GoogleFonts.inter(fontSize: 15, height: 1.6, color: Colors.grey.shade700)),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'Book Appointment',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookAppointmentPage(doctor: doctor))),
                      width: double.infinity,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoTile({super.key, required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
          const SizedBox(height: 8),
          Text(title, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
