import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tegura/models/profile.dart';

class ProfileService extends ChangeNotifier {

  final CollectionReference profilesCollection =
      FirebaseFirestore.instance.collection('profiles');
  final CollectionReference roles =
      FirebaseFirestore.instance.collection('roles');
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final String? uid;

  ProfileService({this.uid});

  // THIS FUNCTION WILL UPDATE THE USER DATA IN THE DATABASE WHEN THE USER SIGNS UP AND WHEN THE USER UPDATES HIS/HER PROFILE
  Future updateUserProfile(
      String uid,
      String username,
      String email,
      String phone,
      String photo,
      String gender,
      String dob,
      bool urStudent,
      String regNumber,
      String campus,
      DocumentReference roleId,
      String lastLoggedInDeviceId) async {

    // RETURN THE USER DATA - IF THE DOC DOESN'T EXIST, IT WILL BE CREATED BY FIRESTORE
    return await profilesCollection.doc(uid).set({
      'uid': uid,
      'username': username,
      'email': email,
      'phone': phone,
      'photo': photo,
      'gender': gender,
      'dob': dob,
      'urStudent': urStudent,
      'regNumber': regNumber,
      'campus': campus,
      'roleId': roleId,
      'lastLoggedInDeviceId': lastLoggedInDeviceId,
    });
  }

  // GET A SINGLE PROFILE FROM A SNAPSHOT USING THE PROFILE MODEL - _profileFromSnapshot
  // FUNCTION CALLED EVERY TIME THE PROFILE DATA CHANGES
  ProfileModel _profileFromSnapshot(DocumentSnapshot documentSnapshot) {
    // roleId IS A REFERENCE TYPE TO ROLES COLLECTION
    final CollectionReference roles =
        FirebaseFirestore.instance.collection('roles');

    // Get the data from the snapshot
    final data = documentSnapshot.data() as Map<String, dynamic>;

    // Check if the 'username' field exists before accessing it
    final username = data.containsKey('username') ? data['username'] : '';

    // Check if the 'email' field exists before accessing it
    final email = data.containsKey('email') ? data['email'] : '';

    // Check if the 'phone' field exists before accessing it
    final phone = data.containsKey('phone') ? data['phone'] : '';

    // Check if the 'photo' field exists before accessing it
    final photo = data.containsKey('photo') ? data['photo'] : '';

    // Check if the 'gender' field exists before accessing it
    final gender = data.containsKey('gender') ? data['gender'] : '';

    // Check if the 'dob' field exists before accessing it
    final dob = data.containsKey('dob') ? data['dob'] : '';

    // Check if the 'urStudent' field exists before accessing it
    final urStudent = data.containsKey('urStudent') ? data['urStudent'] : false;

    // Check if the 'regNumber' field exists before accessing it
    final regNumber = data.containsKey('regNumber') ? data['regNumber'] : '';

    // Check if the 'campus' field exists before accessing it
    final campus = data.containsKey('campus') ? data['campus'] : '';

    // Check if the 'roleId' field exists before accessing it - DocumentReference
    final roleId = data.containsKey('roleId') ? data['roleId'] : roles.doc('1');

    // Check if the 'lastLoggedInDeviceId' field exists before accessing it
    final lastLoggedInDeviceId = data.containsKey('lastLoggedInDeviceId')
        ? data['lastLoggedInDeviceId']
        : '';

    // Return the ProfileModel with the extracted data
    return ProfileModel(
      uid: data['uid'] ?? documentSnapshot.id,
      username: username,
      email: email,
      phone: phone,
      photo: photo,
      gender: gender,
      dob: dob,
      urStudent: urStudent,
      regNumber: regNumber,
      campus: campus,
      roleId: roleId,
      lastLoggedInDeviceId: lastLoggedInDeviceId,
    );
  }

  Stream<ProfileModel?> getCurrentProfileByID(String uid) {
    return profilesCollection.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return _profileFromSnapshot(snapshot);
      } else {
        return null;
      }
    });
  }

  // GET A SINGLE USER PROFILE STREAM - CURRENT LOGGED IN USER PROFILE USING UID
  Stream<ProfileModel?>? getCurrentProfile(String? uid, String? deviceId) {
    if (uid == null ||
        uid.isEmpty ||
        deviceId == null ||
        deviceId.isEmpty ||
        deviceId == '') {
      return null;
    }

    return profilesCollection.doc(uid).snapshots().map((documentSnapshot) {
      if (documentSnapshot.exists) {
        return _profileFromSnapshot(documentSnapshot);
      } else {
        updateUserProfile(uid, '', '', '', '', '', '', false, '', '',
            roles.doc('1'), deviceId);
        return null;
      }
    });
  }
}
