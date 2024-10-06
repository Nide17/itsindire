// DEFINING PROFILE MODEL TO REPRESENT THE USER
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid; // UNIQUE ID OF THE USER - FROM FIREBASE
  final String? email; // UNIQUE EMAIL OF THE USER - FROM FIREBASE
  final String? displayName; // DISPLAYNAME OF THE USER

  UserModel(this.email, this.displayName, {required this.uid});

  @override
  String toString() {
    return "UserModel {id: $uid, email: $email, displayName: $displayName}";
  }

  static fromFirebaseUser(User? usr) {
    if (usr == null) {
      return null;
    }

    return UserModel(usr.email!, usr.displayName!, uid: usr.uid);
  }
}
