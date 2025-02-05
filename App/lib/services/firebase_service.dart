import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bill_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a new bill
  Future<void> addBill(Bill bill) async {
    try {
      // Add the bill document
      await _firestore.collection('bills').add(bill.toMap());

      // Optionally, update a user's total points in a separate collection
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final userDoc = _firestore.collection('users').doc(userId);
        await _firestore.runTransaction((transaction) async {
          final userSnapshot = await transaction.get(userDoc);
          if (userSnapshot.exists) {
            final currentPoints = userSnapshot.data()?['total_points'] ?? 0;
            transaction.update(userDoc, {
              'total_points': currentPoints + bill.rewardPoints,
            });
          } else {
            transaction.set(userDoc, {
              'total_points': bill.rewardPoints,
            });
          }
        });
      }
    } catch (e) {
      print('Error adding bill: $e');
      throw e;
    }
  }

  // Get all bills for current user
  Stream<List<Bill>> getUserBills() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('bills')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Bill.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Get all bills (for admin purposes)
  Stream<List<Bill>> getAllBills() {
    return _firestore
        .collection('bills')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Bill.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}