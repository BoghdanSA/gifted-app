import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addRecipient(String name, String relationship, DateTime? birthday) async {
    await _db.collection('users').doc(uid).collection('recipients').add({
      'name': name,
      'relationship': relationship,
      'birthday': birthday,
    });
  }

  Stream<QuerySnapshot> getRecipients() {
    return _db.collection('users').doc(uid).collection('recipients').snapshots();
  }

  // Add more database methods here as needed
}