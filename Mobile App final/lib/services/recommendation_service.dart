import '../models/recommendation.dart';
import '../models/hospital.dart';
import 'hospital_service.dart';

class RecommendationService {
  final HospitalService _hospitalService = HospitalService();

  Future<List<Recommendation>> getRecommendations({
    required String disease,
    required double lat,
    required double lng,
    String? specialization,
    bool icuRequired = false,
    bool roomRequired = false,
  }) async {
    // BACKEND AI API INTEGRATION POINT: 
    // This is where you would call the AI model service on the backend.

    final hospitals =
    await _hospitalService.getHospitals();
    
    List<Recommendation> recommendations = [];

    for (var h in hospitals) {
      double score = 0;
      List<String> reasons = [];

      // Temporary Local Ranking Logic
      // 1. Distance (Lower is better)
      if ((h.distanceKm ?? 100) < 5) {
        score += 40;
        reasons.add('Very close to your location');
      } else if ((h.distanceKm ?? 100) < 15) {
        score += 20;
        reasons.add('Moderate distance');
      }

      // 2. Emergency Availability
      if (h.emergencyAvailable) {
        score += 30;
        reasons.add('Emergency services available');
      }

      // 3. Specialization match (Simple mock match)
      if (specialization != null) {
        bool hasSpecialist = h.doctors.any((d) => 
          d.specialization.toLowerCase().contains(specialization.toLowerCase()));
        if (hasSpecialist) {
          score += 30;
          reasons.add('Specialized doctors available for $specialization');
        }
      }

      // 4. ICU/Room requirement
      if (icuRequired && h.availableIcuCount > 0) {
        score += 20;
        reasons.add('ICU beds available');
      }
      if (roomRequired && h.availableRoomCount > 0) {
        score += 15;
        reasons.add('Rooms available');
      }

      // 5. Rating
      score += h.rating * 5;

      recommendations.add(Recommendation(
        hospital: h,
        score: score,
        reasons: reasons,
      ));
    }

    // Sort by score descending
    recommendations.sort((a, b) => b.score.compareTo(a.score));
    
    return recommendations;
  }
}
