
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/medicine.dart';

class MedicineService {
  MedicineService();

  // Get the current user's medicine collection
  CollectionReference<Map<String, dynamic>>
      get _medicines {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Please log in first.');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('medicines');
  }

  // READ: Get medicines belonging to the current user
  Stream<List<Medicine>> getMedicines() {
    return _medicines
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(Medicine.fromFirestore)
          .toList();
    });
  }

  // CREATE: Add medicine to the current user's inventory
  Future<void> addMedicine(Medicine medicine) async {
    await _medicines.add(medicine.toMap());
  }

  // UPDATE: Edit medicine in the current user's inventory
  Future<void> updateMedicine(Medicine medicine) async {
    await _medicines
        .doc(medicine.id)
        .update(medicine.toMap());
  }

  // DELETE: Remove medicine from the current user's inventory
  Future<void> deleteMedicine(String id) async {
    await _medicines.doc(id).delete();
  }
}
