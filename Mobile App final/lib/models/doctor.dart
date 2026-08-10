enum DoctorStatus {
  available,
  inOperationTheatre,
  unavailable,
}

class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String hospitalId;
  final DoctorStatus status;
  final String? nextAvailableTime;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.hospitalId,
    required this.status,
    this.nextAvailableTime,
  });

  bool get isAvailable {
    return status == DoctorStatus.available;
  }

  String get availabilityText {
    switch (status) {
      case DoctorStatus.available:
        return 'Available';

      case DoctorStatus.inOperationTheatre:
        return 'In Operation Theatre';

      case DoctorStatus.unavailable:
        return 'Unavailable';
    }
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    final statusString =
        json['status']?.toString() ?? 'unavailable';

    DoctorStatus doctorStatus;

    switch (statusString) {
      case 'available':
        doctorStatus = DoctorStatus.available;
        break;

      case 'inOperationTheatre':
        doctorStatus =
            DoctorStatus.inOperationTheatre;
        break;

      default:
        doctorStatus = DoctorStatus.unavailable;
    }

    return Doctor(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      specialization:
      json['specialization']?.toString() ?? '',
      hospitalId:
      json['hospitalId']?.toString() ?? '',
      status: doctorStatus,
      nextAvailableTime:
      json['nextAvailableTime']?.toString(),
    );
  }
}