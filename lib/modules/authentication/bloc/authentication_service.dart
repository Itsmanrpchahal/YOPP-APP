import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

abstract class BaseAuthService {
  Future<UserCredential> signIn(String email, String password);

  Future<UserCredential> signUp(String email, String password);

  Future<User> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> sendResetPassword(String email);

  Future<void> deleteAccount(String userId, String reason);
}

class AuthService implements BaseAuthService {
  Future<UserCredential> signIn(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(result);
      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }else {
        throw Exception(e.message);
      }

    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
      throw Exception(e.message);
    }
  }

  Future<User> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    return;
  }

  Future<void> sendEmailVerification() async {
    User user = FirebaseAuth.instance.currentUser;
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    return user.emailVerified;
  }

  Future<void> sendResetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("sendResetPassword");

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    }
  }

  updateProfile(String name, String photoUrl) async {
    await FirebaseAuth.instance.currentUser
        .updateProfile(displayName: name, photoURL: photoUrl);
  }

  @override
  Future<void> deleteAccount(String userId, String reason) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user.reload();

      final uid = userId ?? user.uid;

      await FirebaseFirestore.instance
          .collection("Deleted")
          .doc(uid)
          .set({'userId': uid, 'reason': reason});

      await FirebaseAuth.instance.currentUser.delete();
    } on FirebaseException catch (e) {
      // print(e.message);

      throw Exception(e.message);
    }
  }
}
