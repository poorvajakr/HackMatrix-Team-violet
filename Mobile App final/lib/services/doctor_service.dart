import '../models/doctor.dart';
import '../models/hospital.dart';
import 'hospital_service.dart';

class DoctorService {
  final HospitalService _hospitalService = HospitalService();

  Future<List<Doctor>> getDoctorsForHospital(String hospitalId) async {
    // BACKEND INTEGRATION POINT: Fetch doctors from API
    final hospital = await _hospitalService.getHospitalById(hospitalId);
    return hospital?.doctors ?? [];
  }

  Future<List<Doctor>> searchDoctors(String query) async {
    // BACKEND INTEGRATION POINT: Search doctors via API
    // For now, search across all mock hospitals
    final List<Hospital> allHospitals = await _hospitalService.searchHospitals('');
    List<Doctor> allDoctors = [];
    for (var h in allHospitals) {
      allDoctors.addAll(h.doctors);
    }
    return allDoctors
        .where((d) => d.name.toLowerCase().contains(query.toLowerCase()) || 
                      d.specialization.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<bool> isDoctorAvailable(String doctorId) async {
    // BACKEND INTEGRATION POINT: Check real-time status
    return true; // Simplified for mock
  }
}
