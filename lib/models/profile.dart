// DEFINING USER MODEL TO REPRESENT THE USER
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  String? uid; // UNIQUE ID OF THE USER - FROM FIREBASE
  String? username;
  String? email;
  String? phone;
  String? photo;
  String? gender;
  String? dob;
  bool? urStudent;
  String? regNumber;
  String? campus;
  DocumentReference? roleId; // Reference to the role of the user
  String? sessionID;

  ProfileModel(
      {this.uid,
      this.username,
      this.email,
      this.phone,
      this.photo,
      this.gender,
      this.dob,
      this.urStudent,
      this.regNumber,
      this.campus,
      this.roleId,
      this.sessionID});

  // RETURN CURRENT PROFILE OBJECT FOR APPBAR AND NOTIFY LISTENERS
  dynamic get currentUserProfile {
    return this;
  }

  // UPDATE PROFILE OBJECT AND NOTIFY LISTENERS
  void updateProfile(ProfileModel profile) {
    this.uid = profile.uid;
    this.username = profile.username;
    this.email = profile.email;
    this.phone = profile.phone;
    this.photo = profile.photo;
    this.gender = profile.gender;
    this.dob = profile.dob;
    this.urStudent = profile.urStudent;
    this.regNumber = profile.regNumber;
    this.campus = profile.campus;
    this.roleId = profile.roleId;
    this.sessionID = profile.sessionID;
  }

  // TO STRING
  @override
  String toString() {
    return "ProfileModel {id: $uid, username: $username, email: $email, phone: $phone, photo: $photo, gender: $gender, dob: $dob, urStudent: $urStudent, regNumber: $regNumber, campus: $campus, roleId: $roleId, sessionID: $sessionID}";
  }
}
