import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carepilot/models/doctor_model.dart';
import 'package:carepilot/services/doctor_service.dart';
import 'package:carepilot/screens/doctor_detail_page.dart';
import 'package:carepilot/widgets/doctor_card.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final DoctorService _doctorService = DoctorService();
  final TextEditingController _searchController = TextEditingController();
  
  List<DoctorModel> _doctors = [];
  List<DoctorModel> _filteredDoctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
    _searchController.addListener(_filterDoctors);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctors() async {
    final doctors = await _doctorService.getAllDoctors();
    setState(() {
      _doctors = doctors;
      _filteredDoctors = doctors;
      _isLoading = false;
    });
  }

  void _filterDoctors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDoctors = query.isEmpty
          ? _doctors
          : _doctors.where((d) => d.name.toLowerCase().contains(query) || d.specialty.toLowerCase().contains(query)).toList();
    });
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
        title: Text('Find Doctors', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search doctors or specialties...',
                      hintStyle: GoogleFonts.inter(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredDoctors.isEmpty
                      ? Center(child: Text('No doctors found', style: GoogleFonts.inter(fontSize: 16, color: Colors.grey)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(24),
                          itemCount: _filteredDoctors.length,
                          itemBuilder: (context, index) {
                            final doctor = _filteredDoctors[index];
                            return DoctorCard(
                              doctor: doctor,
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailPage(doctor: doctor))),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
