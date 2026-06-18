import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentController {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getStudentFeeList()
  async {

    List<Map<String, dynamic>> result = [];

    QuerySnapshot feeSnapshot =
        await _firestore.collection('Fee').get();

    QuerySnapshot studentSnapshot =
        await _firestore.collection('Student').get();

    for (var feeDoc in feeSnapshot.docs) {

      var fee =
          feeDoc.data() as Map<String, dynamic>;

      String studentID =
          fee['StudentID'] ?? '';

      try {

        var studentDoc =
            studentSnapshot.docs.firstWhere(
          (doc) =>
              (doc.data()
                  as Map<String, dynamic>)['StudentID']
              == studentID,
        );

        var student =
            studentDoc.data()
                as Map<String, dynamic>;

        result.add({
          "student": student,
          "fee": fee,
        });

      } catch (e) {

        result.add({
          "student": {},
          "fee": fee,
        });

      }
    }

    return result;
  }

  Stream<QuerySnapshot> getFeeStream() {
    return _firestore
        .collection('Fee')
        .snapshots();
  }
}