import 'package:cloud_firestore/cloud_firestore.dart';

class FeeController {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Get all fee records
  Future<QuerySnapshot> getAllFees() async {
    return await _firestore
        .collection('Fee')
        .get();
  }

  // Get fee by Student ID
  Future<QuerySnapshot> getFeeByStudentID(
      String studentID) async {
    return await _firestore
        .collection('Fee')
        .where(
          'StudentID',
          isEqualTo: studentID,
        )
        .get();
  }
}