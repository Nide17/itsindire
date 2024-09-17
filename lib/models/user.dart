// DEFINING PROFILE MODEL TO REPRESENT THE USER
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid; // UNIQUE ID OF THE USER - FROM FIREBASE
  final String? email; // UNIQUE EMAIL OF THE USER - FROM FIREBASE
  
  UserModel(this.email, {required this.uid});

  @override
  String toString() {
    return "UserModel {id: $uid, email: $email}";
  }

  static fromFirebaseUser(User? usr) {
    if (usr == null) {
      return null;
    }

    return UserModel(usr.email!, uid: usr.uid);
  }
}
