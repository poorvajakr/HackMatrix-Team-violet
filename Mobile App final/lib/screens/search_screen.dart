import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/hospital.dart';
import '../models/doctor.dart';
import '../services/hospital_service.dart';
import '../services/doctor_service.dart';
import '../widgets/hospital_card.dart';
import '../widgets/doctor_card.dart';
import 'hospital_details_screen.dart';

class SearchScreen extends StatefulWidget {
  final String query;

  const SearchScreen({super.key, required this.query});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final HospitalService _hospitalService = HospitalService();
  final DoctorService _doctorService = DoctorService();

  List<Hospital> _hospitals = [];
  List<Doctor> _doctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _performSearch();
  }

  Future<void> _performSearch() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      _hospitalService.searchHospitals(widget.query),
      _doctorService.searchDoctors(widget.query),
    ]);
    setState(() {
      _hospitals = results[0] as List<Hospital>;
      _doctors = results[1] as List<Doctor>;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results for “${widget.query}”')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              children: [
                if (_hospitals.isNotEmpty) ...[
                  SectionTitle(
                    title: 'Hospitals',
                    subtitle: '${_hospitals.length} matches',
                  ),
                  const SizedBox(height: 12),
                  ..._hospitals.map(
                    (hospital) => HospitalCard(
                      hospital: hospital,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HospitalDetailsScreen(hospital: hospital),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                if (_doctors.isNotEmpty) ...[
                  SectionTitle(
                    title: 'Doctors',
                    subtitle: '${_doctors.length} matches',
                  ),
                  const SizedBox(height: 12),
                  ..._doctors.map((doctor) => DoctorCard(doctor: doctor)),
                ],
                if (_hospitals.isEmpty && _doctors.isEmpty)
                  const PortalPanel(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Center(
                        child: Text(
                          'No results found.',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
