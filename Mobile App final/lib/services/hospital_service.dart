import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:medsyncc/models/hospital.dart';
import 'package:medsyncc/models/doctor.dart';
import 'package:medsyncc/models/icu.dart';
import 'package:medsyncc/models/room.dart';

class HospitalService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ============================================================
  // SAFE DATA CONVERSION
  // ============================================================

  double _toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString().trim(),
    ) ??
        0.0;
  }

  int _toInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString().trim(),
    ) ??
        0;
  }

  bool _toBool(dynamic value) {
    if (value == null) {
      return false;
    }

    if (value is bool) {
      return value;
    }

    final text =
    value.toString().trim().toLowerCase();

    return text == 'true' ||
        text == '1' ||
        text == 'yes';
  }

  String _toStringValue(
      dynamic value, {
        String defaultValue = '',
      }) {
    if (value == null) {
      return defaultValue;
    }

    final text =
    value.toString().trim();

    if (text.isEmpty) {
      return defaultValue;
    }

    return text;
  }

  // ============================================================
  // LOAD ALL HOSPITALS
  // ============================================================

  Future<List<Hospital>> getHospitals() async {
    final hospitalSnapshot =
    await _firestore
        .collection('hospitals')
        .get();

    final List<Hospital> hospitals = [];

    for (final hospitalDoc
    in hospitalSnapshot.docs) {
      try {
        final hospitalData =
        hospitalDoc.data();

        debugPrint(
          'Loading hospital ${hospitalDoc.id}: $hospitalData',
        );

        // ======================================================
        // BEDS / ICU
        //
        // hospitals/{hospitalId}/beds/current
        // ======================================================

        int icuAvailable = 0;
        int generalAvailable = 0;

        try {
          final bedDocument =
          await hospitalDoc.reference
              .collection('beds')
              .doc('current')
              .get();

          if (bedDocument.exists) {
            final bedData =
            bedDocument.data();

            icuAvailable =
                _toInt(
                  bedData?['icuAvailable'],
                );

            generalAvailable =
                _toInt(
                  bedData?['generalAvailable'],
                );

            debugPrint(
              '${hospitalDoc.id} beds -> '
                  'ICU: $icuAvailable, '
                  'General: $generalAvailable',
            );
          } else {
            debugPrint(
              '${hospitalDoc.id}: '
                  'beds/current does not exist',
            );
          }
        } catch (e) {
          debugPrint(
            '${hospitalDoc.id}: '
                'bed loading error: $e',
          );
        }

        final List<Icu> icus =
        List.generate(
          icuAvailable,
              (index) => Icu(
            id: 'icu-${index + 1}',
            type: 'ICU',
            isAvailable: true,
          ),
        );

        final List<Room> rooms =
        List.generate(
          generalAvailable,
              (index) => Room(
            id: 'general-${index + 1}',
            type: 'General',
            isAvailable: true,
            price: 0,
          ),
        );

        // ======================================================
        // DOCTORS
        //
        // hospitals/{hospitalId}/doctors/{doctorId}
        // ======================================================

        final List<Doctor> doctors = [];

        try {
          final doctorSnapshot =
          await hospitalDoc.reference
              .collection('doctors')
              .get();

          debugPrint(
            'Hospital ${hospitalDoc.id} '
                'doctor count: '
                '${doctorSnapshot.docs.length}',
          );

          for (final doctorDoc
          in doctorSnapshot.docs) {
            final doctorData =
            doctorDoc.data();

            final String firebaseStatus =
            _toStringValue(
              doctorData['status'],
            ).toLowerCase();

            DoctorStatus mappedStatus;

            if (firebaseStatus ==
                'available') {
              mappedStatus =
                  DoctorStatus.available;
            } else if (
            firebaseStatus ==
                'in-operation-theatre' ||
                firebaseStatus ==
                    'inoperationtheatre' ||
                firebaseStatus ==
                    'in operation theatre' ||
                firebaseStatus == 'ot') {
              mappedStatus =
                  DoctorStatus
                      .inOperationTheatre;
            } else {
              mappedStatus =
                  DoctorStatus.unavailable;
            }

            final doctor =
            Doctor(
              id:
              doctorDoc.id,

              name:
              _toStringValue(
                doctorData['name'],
                defaultValue:
                'Unknown Doctor',
              ),

              specialization:
              _toStringValue(
                doctorData['specialty'] ??
                    doctorData[
                    'specialization'],
              ),

              hospitalId:
              hospitalDoc.id,

              status:
              mappedStatus,

              nextAvailableTime:
              doctorData[
              'nextSlot']
                  ?.toString(),
            );

            doctors.add(
              doctor,
            );

            debugPrint(
              'Doctor -> '
                  '${doctor.name}, '
                  '${doctor.specialization}, '
                  '$firebaseStatus',
            );
          }
        } catch (e) {
          debugPrint(
            '${hospitalDoc.id}: '
                'doctor loading error: $e',
          );
        }

        // ======================================================
        // HOSPITAL INFORMATION
        // ======================================================

        final String hospitalName =
        _toStringValue(
          hospitalData['name'] ??
              hospitalData[
              'hospitalName'] ??
              hospitalData[
              'hospital_name'],
          defaultValue:
          'Unknown Hospital',
        );

        final String hospitalAddress =
        _toStringValue(
          hospitalData['address'] ??
              hospitalData[
              'hospitalAddress'],
        );

        final String phone =
        _toStringValue(
          hospitalData['contact'] ??
              hospitalData['phone'],
        );

        final double rating =
        _toDouble(
          hospitalData['rating'],
        );

        final double latitude =
        _toDouble(
          hospitalData['latitude'] ??
              hospitalData['lat'],
        );

        final double longitude =
        _toDouble(
          hospitalData['longitude'] ??
              hospitalData['lng'] ??
              hospitalData['lon'],
        );

        final bool emergencyAvailable =
        _toBool(
          hospitalData[
          'emergencyAvailable'] ??
              hospitalData[
              'emergency'],
        );

        final hospital =
        Hospital(
          id:
          hospitalDoc.id,

          name:
          hospitalName,

          address:
          hospitalAddress,

          latitude:
          latitude,

          longitude:
          longitude,

          distanceKm:
          null,

          doctors:
          doctors,

          icus:
          icus,

          rooms:
          rooms,

          emergencyAvailable:
          emergencyAvailable,

          rating:
          rating,

          phone:
          phone,
        );

        hospitals.add(
          hospital,
        );

        debugPrint(
          'Loaded ${hospital.name} -> '
              'rating=${hospital.rating}, '
              'ICU=${hospital.availableIcuCount}, '
              'Rooms=${hospital.availableRoomCount}, '
              'Doctors=${hospital.doctors.length}, '
              'Available doctors='
              '${hospital.availableDoctors.length}',
        );
      } catch (e, stackTrace) {
        debugPrint(
          'Failed to load hospital '
              '${hospitalDoc.id}: $e',
        );

        debugPrint(
          stackTrace.toString(),
        );
      }
    }

    return hospitals;
  }

  // ============================================================
  // SEARCH
  //
  // Supports:
  // hospital name
  // hospital address
  // doctor name
  // specialization
  // ============================================================

  Future<List<Hospital>> searchHospitals(
      String query,
      ) async {
    final hospitals =
    await getHospitals();

    final String searchQuery =
    query
        .trim()
        .toLowerCase();

    if (searchQuery.isEmpty) {
      return hospitals;
    }

    return hospitals.where(
          (hospital) {
        final bool hospitalMatch =
            hospital.name
                .toLowerCase()
                .contains(
              searchQuery,
            ) ||
                hospital.address
                    .toLowerCase()
                    .contains(
                  searchQuery,
                );

        final bool doctorMatch =
        hospital.doctors.any(
              (doctor) {
            return doctor.name
                .toLowerCase()
                .contains(
              searchQuery,
            ) ||
                doctor.specialization
                    .toLowerCase()
                    .contains(
                  searchQuery,
                );
          },
        );

        return hospitalMatch ||
            doctorMatch;
      },
    ).toList();
  }

  // ============================================================
  // GET ONE HOSPITAL
  // ============================================================

  Future<Hospital?> getHospitalById(
      String id,
      ) async {
    try {
      final hospitals =
      await getHospitals();

      return hospitals.firstWhere(
            (hospital) =>
        hospital.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}