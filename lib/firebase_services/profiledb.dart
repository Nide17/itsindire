import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/models/profile.dart';

class ProfileService extends ChangeNotifier {
  final CollectionReference profilesCollection =
      FirebaseFirestore.instance.collection('profiles');
  final CollectionReference roles =
      FirebaseFirestore.instance.collection('roles');
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
      String sessionID) async {
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
      'sessionID': sessionID,
    });
  }

  // SINGLE PROFILE FROM A SNAPSHOT USING THE PROFILE MODEL - _profileFromSnapshot
  // FUNCTION CALLED EVERY TIME THE PROFILE DATA CHANGES
  ProfileModel _profileFromSnapshot(DocumentSnapshot documentSnapshot) {
    final CollectionReference roles =
        FirebaseFirestore.instance.collection('roles');

    // Get the data from the snapshot
    final data = documentSnapshot.data() as Map<String, dynamic>;
    final username = data.containsKey('username') ? data['username'] : '';
    final email = data.containsKey('email') ? data['email'] : '';
    final phone = data.containsKey('phone') ? data['phone'] : '';
    final photo = data.containsKey('photo') ? data['photo'] : '';
    final gender = data.containsKey('gender') ? data['gender'] : '';
    final dob = data.containsKey('dob') ? data['dob'] : '';
    final urStudent = data.containsKey('urStudent') ? data['urStudent'] : false;
    final regNumber = data.containsKey('regNumber') ? data['regNumber'] : '';
    final campus = data.containsKey('campus') ? data['campus'] : '';
    final roleId = data.containsKey('roleId') ? data['roleId'] : roles.doc('1');
    final sessionID = data.containsKey('sessionID')
        ? data['sessionID']
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
      sessionID: sessionID,
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
  Stream<ProfileModel?>? getCurrentProfile(String? uid, String? sessionID) {
    if (uid == null ||
        uid.isEmpty ||
        sessionID == null ||
        sessionID.isEmpty) {
      return null;
    }

    return profilesCollection.doc(uid).snapshots().map((documentSnapshot) {
      if (documentSnapshot.exists) {
        return _profileFromSnapshot(documentSnapshot);
      } else {
        updateUserProfile(uid, '', '', '', '', '', '', false, '', '',
            roles.doc('1'), sessionID);
        return null;
      }
    });
  }
}
