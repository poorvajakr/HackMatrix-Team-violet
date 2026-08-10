import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHospitalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getHospitals() {
    return _firestore.collection('hospitals').snapshots();
  }
}