import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carepilot/models/symptom_model.dart';
import 'package:carepilot/models/user_model.dart';
import 'package:carepilot/services/symptom_service.dart';
import 'package:carepilot/services/user_service.dart';
import 'package:carepilot/widgets/custom_button.dart';

class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({super.key});

  @override
  State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  final SymptomService _symptomService = SymptomService();
  final UserService _userService = UserService();
  final TextEditingController _notesController = TextEditingController();

  UserModel? _currentUser;
  List<String> _selectedSymptoms = [];
  String _selectedSeverity = 'Mild';
  String _selectedDuration = 'Less than a day';
  bool _isLoading = true;
  bool _showResults = false;

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

  Future<void> _submitSymptoms() async {
    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one symptom')),
      );
      return;
    }

    if (_currentUser == null) return;

    final symptom = SymptomModel(
      id: 'symptom_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUser!.id,
      symptoms: _selectedSymptoms,
      severity: _selectedSeverity,
      duration: _selectedDuration,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _symptomService.createSymptom(symptom);

    setState(() => _showResults = true);
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
        title: Text('Symptom Checker', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: _showResults ? _buildResults() : _buildSymptomForm(),
    );
  }

  Widget _buildSymptomForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.health_and_safety, size: 48, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text('Tell us what you\'re experiencing', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Select your symptoms and we\'ll provide guidance', style: GoogleFonts.inter(fontSize: 15, color: Colors.grey)),
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
                Text('Select Symptoms', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _symptomService.getCommonSymptoms().map((symptom) {
                    final isSelected = _selectedSymptoms.contains(symptom);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedSymptoms.remove(symptom);
                          } else {
                            _selectedSymptoms.add(symptom);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(context).colorScheme.primary : const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(symptom, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : Colors.grey.shade700)),
                      ),
                    );
                  }).toList(),
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
                Text('Severity', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: SeverityOption(label: 'Mild', isSelected: _selectedSeverity == 'Mild', onTap: () => setState(() => _selectedSeverity = 'Mild'))),
                    const SizedBox(width: 8),
                    Expanded(child: SeverityOption(label: 'Moderate', isSelected: _selectedSeverity == 'Moderate', onTap: () => setState(() => _selectedSeverity = 'Moderate'))),
                    const SizedBox(width: 8),
                    Expanded(child: SeverityOption(label: 'Severe', isSelected: _selectedSeverity == 'Severe', onTap: () => setState(() => _selectedSeverity = 'Severe'))),
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
                Text('Duration', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedDuration,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  items: ['Less than a day', '1-3 days', '4-7 days', 'More than a week'].map((duration) => DropdownMenuItem(value: duration, child: Text(duration))).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedDuration = value);
                  },
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
                Text('Additional Notes', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Any other details...',
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
            child: CustomButton(text: 'Check Symptoms', onPressed: _submitSymptoms, width: double.infinity),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Icon(Icons.check_circle, size: 64, color: Colors.green.shade600),
                  const SizedBox(height: 16),
                  Text('Symptoms Recorded', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('We\'ve saved your symptom information', style: GoogleFonts.inter(fontSize: 15, color: Colors.grey.shade700)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recommendations', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  RecommendationItem(icon: Icons.local_hospital, text: 'Consider scheduling a consultation with a doctor'),
                  const SizedBox(height: 12),
                  RecommendationItem(icon: Icons.water_drop, text: 'Stay hydrated and get plenty of rest'),
                  const SizedBox(height: 12),
                  RecommendationItem(icon: Icons.warning_amber, text: 'Seek immediate care if symptoms worsen'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(text: 'Book Consultation', onPressed: () => Navigator.pop(context), width: double.infinity),
            const SizedBox(height: 12),
            CustomButton(text: 'Back to Home', onPressed: () => Navigator.pop(context), isOutlined: true, width: double.infinity),
          ],
        ),
      ),
    );
  }
}

class SeverityOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SeverityOption({super.key, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade700)),
        ),
      ),
    );
  }
}

class RecommendationItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const RecommendationItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle),
          child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 14, height: 1.5))),
      ],
    );
  }
}
