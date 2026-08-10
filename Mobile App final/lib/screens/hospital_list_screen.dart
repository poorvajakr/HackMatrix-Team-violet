import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/hospital.dart';
import '../widgets/hospital_card.dart';
import 'hospital_details_screen.dart';

class HospitalListScreen extends StatelessWidget {
  final List<Hospital> hospitals;
  final String searchQuery;

  const HospitalListScreen({
    super.key,
    required this.hospitals,
    this.searchQuery = '',
  });

  int _matchingDoctorCount(Hospital hospital) {
    final search = searchQuery.trim().toLowerCase();

    if (search.isEmpty) return 0;

    return hospital.availableDoctors.where((doctor) {
      return doctor.specialization.toLowerCase().contains(search);
    }).length;
  }

  String? _getSearchLabel(Hospital hospital) {
    if (searchQuery.trim().isEmpty) return null;

    final count = _matchingDoctorCount(hospital);
    if (count == 0) return null;

    final formattedQuery =
        searchQuery[0].toUpperCase() + searchQuery.substring(1);

    return count == 1
        ? '1 $formattedQuery doctor available'
        : '$count $formattedQuery doctors available';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          searchQuery.isEmpty ? 'All hospitals' : 'Results for “$searchQuery”',
        ),
      ),
      body: hospitals.isEmpty
          ? const Center(
              child: Text(
                'No hospitals available',
                style: TextStyle(color: AppColors.muted),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              itemCount: hospitals.length,
              itemBuilder: (context, index) {
                final hospital = hospitals[index];

                return HospitalCard(
                  hospital: hospital,
                  searchMatchLabel: _getSearchLabel(hospital),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            HospitalDetailsScreen(hospital: hospital),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
