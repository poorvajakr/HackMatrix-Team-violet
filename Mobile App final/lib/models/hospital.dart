import 'doctor.dart';
import 'icu.dart';
import 'room.dart';

class Hospital {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double? distanceKm;

  final List<Doctor> doctors;
  final List<Icu> icus;
  final List<Room> rooms;

  final bool emergencyAvailable;
  final double rating;
  final String phone;

  const Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.distanceKm,
    required this.doctors,
    required this.icus,
    required this.rooms,
    required this.emergencyAvailable,
    required this.rating,
    required this.phone,
  });

  int get availableIcuCount {
    return icus
        .where((icu) => icu.isAvailable)
        .length;
  }

  int get availableRoomCount {
    return rooms
        .where((room) => room.isAvailable)
        .length;
  }

  List<Doctor> get availableDoctors {
    return doctors
        .where((doctor) => doctor.isAvailable)
        .toList();
  }

  factory Hospital.fromJson(
      Map<String, dynamic> json,
      ) {
    return Hospital(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',

      latitude:
      (json['latitude'] as num?)?.toDouble() ?? 0.0,

      longitude:
      (json['longitude'] as num?)?.toDouble() ?? 0.0,

      distanceKm:
      (json['distanceKm'] as num?)?.toDouble(),

      doctors:
      (json['doctors'] as List<dynamic>? ?? [])
          .map(
            (doctor) => Doctor.fromJson(
          doctor as Map<String, dynamic>,
        ),
      )
          .toList(),

      icus:
      (json['icus'] as List<dynamic>? ?? [])
          .map(
            (icu) => Icu.fromJson(
          icu as Map<String, dynamic>,
        ),
      )
          .toList(),

      rooms:
      (json['rooms'] as List<dynamic>? ?? [])
          .map(
            (room) => Room.fromJson(
          room as Map<String, dynamic>,
        ),
      )
          .toList(),

      emergencyAvailable:
      json['emergencyAvailable']
      as bool? ??
          false,

      rating:
      (json['rating'] as num?)?.toDouble() ?? 0.0,

      phone:
      json['phone']?.toString() ?? '',
    );
  }
}