import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bustrack/src/features/authentication/controllers/navigations.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String role) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;

      if (user != null) {
        // Save user role in Firestore
        await _firestore.collection('User').doc(user.uid).set({
          'email': email,
          'role': role,
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Handle email already in use error
      } else {
        // Handle other errors
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      } else {}
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();

    // Future resetPassword(String email) async {
    //   try {
    //     await _auth.sendPasswordResetEmail(email: email);
    //   } on FirebaseAuthException catch (e) {
    //     print("Failed to send password reset email: ${e.message}");
    //   }
    // }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print("Failed to send password reset email: ${e.message}");
    }
  }
}
