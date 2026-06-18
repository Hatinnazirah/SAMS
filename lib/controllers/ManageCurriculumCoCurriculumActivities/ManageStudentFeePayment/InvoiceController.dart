import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceController {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Get all invoices
  Future<QuerySnapshot> getAllInvoices() async {
    return await _firestore
        .collection('Invoice')
        .get();
  }

  // Get invoice by Student ID
  Future<QuerySnapshot> getInvoiceByStudentID(
      String studentID) async {
    return await _firestore
        .collection('Invoice')
        .where(
          'StudentID',
          isEqualTo: studentID,
        )
        .get();
  }

  // Get invoice by Payment ID
  Future<QuerySnapshot> getInvoiceByPaymentID(
      String paymentID) async {
    return await _firestore
        .collection('Invoice')
        .where(
          'PaymentID',
          isEqualTo: paymentID,
        )
        .get();
  }
}