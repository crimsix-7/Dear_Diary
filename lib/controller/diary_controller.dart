import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import for Firebase Storage
import '../model/diary_entry_model.dart';
import 'dart:io'; // For File class
import 'package:path/path.dart'; // For basename method


class DiaryController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance; // Instance for Firebase Storage

  // User Authentication
  Future<UserCredential?> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential?> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Diary Entry Management
  Future<bool> addDiaryEntry(DiaryEntry entry) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users/${user.uid}/diary_entries').add(entry.toMap());
      return true;
    }
    return false;
  }

  Future<List<DiaryEntry>> getDiaryEntries() async {
    User? user = _auth.currentUser;
    if (user != null) {
      var snapshot = await _firestore.collection('users/${user.uid}/diary_entries').get();
      return snapshot.docs.map((doc) => DiaryEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    }
    return [];
  }

  Future<void> updateDiaryEntry(String docId, DiaryEntry updatedEntry) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users/${user.uid}/diary_entries').doc(docId).update(updatedEntry.toMap());
    }
  }

  Future<void> deleteDiaryEntry(String docId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users/${user.uid}/diary_entries').doc(docId).delete();
    }
  }

  // Image Management
  Future<String?> uploadImage(String imagePath, String userId) async {
    try {
      File imageFile = File(imagePath); // Local file path
      String fileName = basename(imagePath); // Extracting file name
      String destination = 'images/$userId/$fileName';

      // Upload task
      TaskSnapshot snapshot = await _storage.ref(destination).putFile(imageFile);
      if (snapshot.state == TaskState.success) {
        return await snapshot.ref.getDownloadURL(); // Get image URL after upload
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null;
  }
}
