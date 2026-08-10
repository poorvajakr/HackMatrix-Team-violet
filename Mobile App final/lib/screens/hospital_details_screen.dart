import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/hospital.dart';
import '../widgets/availability_card.dart';
import '../widgets/doctor_card.dart';
import 'booking_screen.dart';
import 'map_screen.dart';

class HospitalDetailsScreen extends StatelessWidget {
  final Hospital hospital;

  const HospitalDetailsScreen({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hospital.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PortalPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.local_hospital_outlined,
                          color: AppColors.cyan,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hospital.name,
                              style: const TextStyle(
                                color: AppColors.text,
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hospital.address,
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 11,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoPill(
                        icon: Icons.star_rounded,
                        label: hospital.rating.toStringAsFixed(1),
                        color: AppColors.warning,
                      ),
                      if (hospital.phone.isNotEmpty)
                        _InfoPill(
                          icon: Icons.phone_outlined,
                          label: hospital.phone,
                          color: AppColors.cyan,
                        ),
                      if (hospital.distanceKm != null)
                        _InfoPill(
                          icon: Icons.near_me_outlined,
                          label:
                              '${hospital.distanceKm!.toStringAsFixed(1)} km away',
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const SectionTitle(
              title: 'Availability',
              subtitle: 'Live resource status from the hospital',
            ),
            const SizedBox(height: 12),
            AvailabilityCard(
              icuAvailable: hospital.availableIcuCount,
              roomsAvailable: hospital.availableRoomCount,
              emergency: hospital.emergencyAvailable,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(
                            hospitalName: hospital.name,
                            lat: hospital.latitude,
                            lng: hospital.longitude,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.directions_outlined),
                    label: const Text('Route'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (hospital.doctors.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(
                              hospital: hospital,
                              doctor: hospital.doctors.first,
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: const Text('Book now'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SectionTitle(
              title: 'Doctors',
              subtitle: '${hospital.availableDoctors.length} available now',
            ),
            const SizedBox(height: 12),
            if (hospital.doctors.isEmpty)
              const PortalPanel(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Center(
                    child: Text(
                      'No doctor information available.',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ),
                ),
              )
            else
              ...hospital.doctors.map(
                (doctor) => DoctorCard(
                  doctor: doctor,
                  onBook: doctor.isAvailable
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(
                                hospital: hospital,
                                doctor: doctor,
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
