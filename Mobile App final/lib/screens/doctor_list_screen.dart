import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/doctor.dart';
import '../widgets/doctor_card.dart';

class DoctorListScreen extends StatelessWidget {
  final List<Doctor> doctors;

  const DoctorListScreen({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctors')),
      body: doctors.isEmpty
          ? const Center(
              child: Text(
                'No doctors available.',
                style: TextStyle(color: AppColors.muted),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                return DoctorCard(doctor: doctors[index]);
              },
            ),
    );
  }
}
