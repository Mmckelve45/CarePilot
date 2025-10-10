import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:carepilot/models/user_model.dart';
import 'package:carepilot/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = _currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user found')));
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
        title: Text('My Profile', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 16),
                  Text(user.name, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(user.email, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
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
                  Text('Personal Information', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ProfileInfoRow(icon: Icons.phone, label: 'Phone', value: user.phone),
                  const SizedBox(height: 16),
                  ProfileInfoRow(icon: Icons.cake, label: 'Date of Birth', value: user.dateOfBirth != null ? DateFormat('MMM dd, yyyy').format(user.dateOfBirth!) : 'Not set'),
                  const SizedBox(height: 16),
                  ProfileInfoRow(icon: Icons.person_outline, label: 'Gender', value: user.gender),
                  const SizedBox(height: 16),
                  ProfileInfoRow(icon: Icons.bloodtype, label: 'Blood Type', value: user.bloodType ?? 'Not set'),
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
                  Text('Medical Information', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning_amber, color: Theme.of(context).colorScheme.primary, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Allergies', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(user.allergies.isNotEmpty ? user.allergies.join(', ') : 'None', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.description, color: Theme.of(context).colorScheme.primary, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Medical History', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(user.medicalHistory ?? 'No records', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoRow({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
