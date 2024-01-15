// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/firebase_services/profiledb.dart';

// CLASS FOR HANDLING AUTH SERVICES
class AuthService {
  // INSTANCE OF THE FIREBASE AUTHENTICATION
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  // roleId IS A REFERENCE TYPE TO ROLES COLLECTION
  final CollectionReference roles =
      FirebaseFirestore.instance.collection('roles');

  // CREATE USER OBJECT(MODEL) BASED ON FIREBASE USER
  UserModel? _userFromFirebaseUser(User usr) {
    // RETURN USER WITH MODEL STRUCTURE
    return UserModel(usr.email, uid: usr.uid);
  }

  // AUTH CHANGE USER STREAM - LISTENS TO AUTH CHANGES
  Stream<UserModel?> get getUser {
    // GET PROFILE MODEL STREAM
    return _authInstance.authStateChanges().map((User? usr) {
      // IF USER IS NOT NULL
      if (usr != null) {
        // RETURN THE USER
        return _userFromFirebaseUser(usr);
      } else {
        // RETURN NULL
        return null;
      }
    });
  }

  // SIGN IN WITH EMAIL AND PASSWORD METHOD
  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential resLogin = await _authInstance.signInWithEmailAndPassword(
          email: email, password: password);

      // STRUCTURE USER FROM THE RESULT USING USER MODEL
      User? usr = resLogin.user;

      // RETURN USER
      if (usr != null) {
        return _userFromFirebaseUser(usr);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());

      // RETURN NULL
      return null;
    }
  }

  // REGISTER WITH EMAIL AND PASSWORD METHOD
  Future registerWithEmailAndPassword(String username, String email,
      String password, bool? urStudent, String? regNbr, String? campus) async {
    try {
      // REGISTER WITH EMAIL AND PASSWORD REQUEST - RETURN AUTH RESULT FUTURE
      UserCredential result =
          await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // GET THE USER FROM THE RESULT
      User? user = result.user;

      // SAVE THE USER DATA TO PROFILE COLLECTION
      if (user != null) {
        await ProfileService(uid: user.uid).updateUserProfile(
          user.uid,
          username,
          email,
          '',
          '',
          '',
          '',
          urStudent ?? false,
          regNbr ?? '',
          campus ?? '',
          roles.doc('1'),
        );
      }

      // RETURN THE USER
      if (user != null) {
        return _userFromFirebaseUser(user);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // SIGN OUT METHOD
  Future logOut() async {
    // ASYNC METHOD TO RETURN A FUTURE
    try {
      // SIGN OUT REQUEST
      return await _authInstance.signOut();
    } catch (e) {
      print(e.toString());

      // RETURN NULL
      return null;
    }
  }

  // RESET PASSWORD METHOD
  Future resetPassword(String email) async {
    // ASYNC METHOD TO RETURN A FUTURE
    try {
      // RESET PASSWORD REQUEST
      await _authInstance.sendPasswordResetEmail(email: email);

      // RETURN success
      return 'success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // GET CURRENT USER METHOD - RETURNS THE CURRENT USER
  currentUser() {}
}
