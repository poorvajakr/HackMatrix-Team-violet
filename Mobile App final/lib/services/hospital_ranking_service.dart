import 'package:geolocator/geolocator.dart';

import '../models/hospital.dart';

class RankedHospital {
  final Hospital hospital;
  final double score;
  final int matchingDoctors;
  final double? distanceKm;

  const RankedHospital({
    required this.hospital,
    required this.score,
    required this.matchingDoctors,
    required this.distanceKm,
  });
}

class HospitalRankingService {
  Future<List<RankedHospital>> rankHospitals({
    required List<Hospital> hospitals,
    required String need,
    double? userLatitude,
    double? userLongitude,
    bool icuRequired = false,
  }) async {
    final query = need.trim().toLowerCase();

    final List<RankedHospital> ranked = [];

    for (final hospital in hospitals) {
      final matchingDoctors =
      query.isEmpty
          ? hospital.availableDoctors.length
          : hospital.availableDoctors.where((doctor) {
        final specialization =
        doctor.specialization.toLowerCase();

        final doctorName =
        doctor.name.toLowerCase();

        return specialization.contains(query) ||
            doctorName.contains(query);
      }).length;

      final double doctorScore =
      (matchingDoctors / 5 * 100)
          .clamp(0.0, 100.0)
          .toDouble();

      final int availableCapacity =
      icuRequired
          ? hospital.availableIcuCount
          : hospital.availableRoomCount;

      final double capacityScore =
      (availableCapacity / 10 * 100)
          .clamp(0.0, 100.0)
          .toDouble();

      double? distanceKm;
      double distanceScore = 50.0;

      if (userLatitude != null &&
          userLongitude != null &&
          hospital.latitude != 0 &&
          hospital.longitude != 0) {
        distanceKm =
            Geolocator.distanceBetween(
              userLatitude,
              userLongitude,
              hospital.latitude,
              hospital.longitude,
            ) /
                1000;

        distanceScore =
            (100 - (distanceKm * 2))
                .clamp(0.0, 100.0)
                .toDouble();
      }

      final double ratingScore =
      (hospital.rating / 5 * 100)
          .clamp(0.0, 100.0)
          .toDouble();

      final double score =
          doctorScore * 0.40 +
              capacityScore * 0.25 +
              distanceScore * 0.20 +
              ratingScore * 0.15;

      if (query.isNotEmpty && matchingDoctors == 0) {
        continue;
      }

      ranked.add(
        RankedHospital(
          hospital: hospital,
          score: score,
          matchingDoctors: matchingDoctors,
          distanceKm: distanceKm,
        ),
      );
    }

    ranked.sort(
          (a, b) => b.score.compareTo(a.score),
    );

    return ranked;
  }
}