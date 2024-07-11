import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

final _fireauth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class UserAuthProvider with ChangeNotifier {
  Future<String> loginWithEmail(String email, String password) async {
    try {
      if (email.isEmpty || !EmailValidator.validate(email)) {
        return 'Email tidak valid.';
      }
      if (password.length < 6) {
        return 'Password harus lebih dari 6 karakter.';
      }

      UserCredential user = await _fireauth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // check if user exists in firestore
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isEmpty) {
        // create new user
        await _firestore
            .collection('users')
            .doc(user.user!.uid)
            .set({'username': email, 'email': email, 'money': 0});
      }
      return '';
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            return 'Email tidak valid.';
          case 'wrong-password':
            return 'Password salah.';
          case 'user-not-found':
            return 'Akun tidak ditemukan.';
          default:
            return 'Error tidak diketahui: ${e.code}: ${e.message}';
        }
      }

      return 'Error: $e';
    }
  }

  Future<String> registerWithEmail(
    String username,
    String email,
    String password,
  ) async {
    try {
      if (username.isEmpty) {
        return 'Username tidak boleh kosong.';
      }
      if (password.length < 6) {
        return 'Password harus lebih dari 6 karakter.';
      }
      if (email.isEmpty || !EmailValidator.validate(email)) {
        return 'Email tidak valid.';
      }

      await _fireauth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _fireauth.currentUser!.updateDisplayName(username);

      await _firestore.collection('users').doc(_fireauth.currentUser!.uid).set({
        'username': username,
        'email': email,
        'money': 0,
      });

      return '';
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            return 'Email sudah terdaftar.';
          case 'invalid-email':
            return 'Email tidak valid.';
          case 'weak-password':
            return 'Password terlalu lemah.';
          default:
            return 'Error tidak diketahui: ${e.code}: ${e.message}';
        }
      }

      return 'Error: $e';
    }
  }

  Future<void> logout() async {
    await _fireauth.signOut();
  }
}
