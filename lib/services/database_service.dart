import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Recipients

  Future<void> addRecipient(String name, String relationship, DateTime? birthday) async {
    try {
      await _db.collection('users').doc(uid).collection('recipients').add({
        'name': name,
        'relationship': relationship,
        'birthday': birthday,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding recipient: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getRecipients() {
    return _db.collection('users').doc(uid).collection('recipients')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateRecipient(String recipientId, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(uid).collection('recipients').doc(recipientId).update(data);
    } catch (e) {
      print('Error updating recipient: $e');
      rethrow;
    }
  }

  Future<void> deleteRecipient(String recipientId) async {
    try {
      await _db.runTransaction((transaction) async {
        // Delete the recipient
        transaction.delete(_db.collection('users').doc(uid).collection('recipients').doc(recipientId));
        
        // Delete associated gift ideas
        var giftIdeasSnapshot = await _db.collection('users').doc(uid)
            .collection('recipients').doc(recipientId)
            .collection('giftIdeas').get();
        
        for (var doc in giftIdeasSnapshot.docs) {
          transaction.delete(doc.reference);
        }
      });
    } catch (e) {
      print('Error deleting recipient: $e');
      rethrow;
    }
  }

  // Gift Ideas

  Future<void> addGiftIdea(String recipientId, String idea, double? price) async {
    try {
      await _db.collection('users').doc(uid)
          .collection('recipients').doc(recipientId)
          .collection('giftIdeas').add({
        'idea': idea,
        'price': price,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding gift idea: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getGiftIdeas(String recipientId) {
    return _db.collection('users').doc(uid)
        .collection('recipients').doc(recipientId)
        .collection('giftIdeas')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateGiftIdea(String recipientId, String giftIdeaId, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(uid)
          .collection('recipients').doc(recipientId)
          .collection('giftIdeas').doc(giftIdeaId)
          .update(data);
    } catch (e) {
      print('Error updating gift idea: $e');
      rethrow;
    }
  }

  Future<void> deleteGiftIdea(String recipientId, String giftIdeaId) async {
    try {
      await _db.collection('users').doc(uid)
          .collection('recipients').doc(recipientId)
          .collection('giftIdeas').doc(giftIdeaId)
          .delete();
    } catch (e) {
      print('Error deleting gift idea: $e');
      rethrow;
    }
  }
}