import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/services/profiledb.dart';

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
    return _authInstance
        .authStateChanges()
        .map((User? usr) => _userFromFirebaseUser(usr!));
  }

  // SIGN IN ANONYMOUSLY METHOD
  Future signInAnon() async {
    // ASYNC METHOD TO RETURN A FUTURE
    try {
      // SIGN IN ANONYMOUSLY REQUEST - RETURN AUTH RESULT FUTURE
      UserCredential result = await _authInstance.signInAnonymously();

      // GET THE USER FROM THE RESULT
      User? user = result.user;

      // RETURN THE USER
      return _userFromFirebaseUser(user!);
    } catch (e) {
      // PRINT THE ERROR
      print(e.toString());

      // RETURN NULL
      return null;
    }
  }

  // SIGN IN WITH EMAIL AND PASSWORD METHOD
  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential resLogin = await _authInstance.signInWithEmailAndPassword(
          email: email, password: password);

      // STRUCTURE USER FROM THE RESULT USING USER MODEL
      User? usr = resLogin.user;

      // RETURN USER
      return _userFromFirebaseUser(usr!);
    } catch (e) {
      print(e.toString());

      // RETURN NULL
      return null;
    }
  }

  // REGISTER WITH EMAIL AND PASSWORD METHOD
  Future registerWithEmailAndPassword(
      String username, String email, String password) async {
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
          '',
          email,
          '',
          '',
          '',
          '',
          false,
          '',
          '',
          roles.doc('1'),
        );
      }

      // SHOULD NOT DO ANYTHING
      print('registerWithEmailAndPassword success');

      // RETURN THE USER
      return _userFromFirebaseUser(user!);
    } catch (e) {
      // PRINT THE ERROR
      print(e.toString());
    }
  }

  // SIGN OUT METHOD
  Future logOut() async {
    // ASYNC METHOD TO RETURN A FUTURE
    try {
      print('logOut');

      // SIGN OUT REQUEST
      return await _authInstance.signOut();
    } catch (e) {
      // PRINT THE ERROR
      print(e.toString());

      // RETURN NULL
      return null;
    }
  }

  // SIGN IN WITH GOOGLE METHOD
}
