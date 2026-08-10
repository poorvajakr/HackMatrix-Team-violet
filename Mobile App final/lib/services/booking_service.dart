import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  Future<String> createBooking({
    required String hospitalId,
    required String hospitalName,
    required String doctorId,
    required String doctorName,
    required String specialization,
    required DateTime dateTime,
    required String reason,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Patient is not logged in.');
    }

    final appointmentRef = _firestore
        .collection('hospitals')
        .doc(hospitalId)
        .collection('appointments')
        .doc();

    await appointmentRef.set({
      'patientId': user.uid,
      'patientEmail': user.email ?? '',

      'hospitalId': hospitalId,
      'hospitalName': hospitalName,

      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialization': specialization,

      'requestedTime':
      Timestamp.fromDate(dateTime),

      'reason': reason.trim(),

      // Hospital has not responded yet.
      'status': 'pending',

      'createdAt':
      FieldValue.serverTimestamp(),

      'respondedAt': null,
      'respondedBy': null,
    });

    return appointmentRef.id;
  }
}