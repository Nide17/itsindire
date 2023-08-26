// DEFINING USER MODEL TO REPRESENT THE USER
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileModel extends ChangeNotifier {
  final String? uid; // UNIQUE ID OF THE USER - FROM FIREBASE
  final String? username;
  final String? names;
  final String? email;
  final String? phone;
  final String? photo;
  final String? gender;
  final String? dob;
  final bool? urStudent;
  final String? regNumber;
  final String? campus;
  // roleId IS A REFERENCE TYPE TO ROLES COLLECTION
  final DocumentReference? roleId;

  // CONSTRUCTOR
  ProfileModel(
      {this.uid,
      this.username,
      this.names,
      this.email,
      this.phone,
      this.photo,
      this.gender,
      this.dob,
      this.urStudent,
      this.regNumber,
      this.campus,
      this.roleId});

  // RETURN CURRENT PROFILE OBJECT FOR APPBAR AND NOTIFY LISTENERS
  dynamic get currentUserProfile {
    notifyListeners();
    return this;
  }

  // TO STRING
  @override
  String toString() {
    return "ProfileModel {id: $uid, username: $username, email: $email, roleId: $roleId}";
  }
}
