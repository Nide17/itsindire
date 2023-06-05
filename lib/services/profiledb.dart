import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tegura/models/profile.dart';

class ProfileService {
  // COLLECTIONS REFERENCE - FIRESTORE
  final CollectionReference profilesCollection =
      FirebaseFirestore.instance.collection('profiles');

  final String? uid;

  // CONSTRUCTOR
  ProfileService({this.uid});

  // THIS FUNCTION WILL UPDATE THE USER DATA IN THE DATABASE WHEN THE USER SIGNS UP AND WHEN THE USER UPDATES HIS/HER PROFILE
  Future updateUserProfile(
      String uid,
      String username,
      String names,
      String email,
      String phone,
      String photo,
      String gender,
      String dob,
      bool urStudent,
      String regNumber,
      String campus,
      DocumentReference roleId) async {
    // RETURN THE USER DATA - IF THE DOC DOESN'T EXIST, IT WILL BE CREATED BY FIRESTORE
    return await profilesCollection.doc(uid).set({
      // USER DATA - FIELDS
      'uid': uid,
      'username': username,
      'names': names,
      'email': email,
      'phone': phone,
      'photo': photo,
      'gender': gender,
      'dob': dob,
      'urStudent': urStudent,
      'regNumber': regNumber,
      'campus': campus,
      'roleId': roleId,
    });
  }

  // // GET A LIST OF PROFILES FROM A SNAPSHOT USING THE PROFILE MODEL
  // // FUNCTION CALLED EVERY TIME THE PROFILES DATA CHANGES
  // List<ProfileModel> _profilesListFromSnapshot(QuerySnapshot querySnapshot) {
  //   // RETURN A LIST OF USERS FROM THE SNAPSHOT
  //   return querySnapshot.docs.map((doc) {
  //     return ProfileModel(
  //       // USER DATA - FIELDS
  //       uid: doc.id,
  //       username: doc['username'] ?? '',
  //       names: doc['names'] ?? '',
  //       email: doc['email'] ?? '',
  //       phone: doc['phone'] ?? '',
  //       photo: doc['photo'] ?? '',
  //       gender: doc['gender'] ?? '',
  //       dob: doc['dob'] ?? '',
  //       urStudent: doc['urStudent'] ?? false,
  //       regNumber: doc['regNumber'] ?? '',
  //       campus: doc['campus'] ?? '',
  //       roleId: doc['roleId'] ?? 1,
  //     );
  //   }).toList();
  // }

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

    // Check if the 'names' field exists before accessing it
    final names = data.containsKey('names') ? data['names'] : '';

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

    // Return the ProfileModel with the extracted data
    return ProfileModel(
      uid: data['uid'] ?? documentSnapshot.id,
      username: username,
      names: names,
      email: email,
      phone: phone,
      photo: photo,
      gender: gender,
      dob: dob,
      urStudent: urStudent,
      regNumber: regNumber,
      campus: campus,
      roleId: roleId,
    );
  }

// You can use similar checks for all the fields in the `_profileFromSnapshot` method to avoid the "Bad state: cannot get a field on a DocumentSnapshotPlatform which does not exist" error.

  // // GET ALL USERS PROFILES STREAM
  // Stream<List<ProfileModel>> get userProfiles {
  //   // PRINT THE USER PROFILES ONE BY ONE - USING THE PROFILE MODEL TO REPRESENT THE USER DATA
  //   profilesCollection.snapshots().forEach((snp) {
  //     _profilesListFromSnapshot(snp).forEach((prfl) {
  //       // print(prfl.username);
  //       // print(prfl.roleId);
  //     });
  //   });
  //   return profilesCollection.snapshots().map(_profilesListFromSnapshot);
  // }

  // GET A SINGLE USER PROFILE STREAM - CURRENT LOGGED IN USER PROFILE USING UID
  Stream<ProfileModel?>? getCurrentProfile(String? uid) {
    // CHECK IF CURRENT USER UID IS NULL, IF IT IS, RETURN NULL
    if (uid == null) return null;

    // CHECK IF CURRENT USER PROFILE EXISTS, IF IT DOESN'T EXIST, CREATE IT, IF IT EXISTS, RETURN IT
    profilesCollection.doc(uid).get().then((doc) {
      if (doc.exists) {
        print('\nDB Document exist with data: ${doc.data()}');
        return profilesCollection
            .doc(uid)
            .snapshots()
            .map(_profileFromSnapshot);
      } else {
        print("\nDB No such document!");
        return null;
      }
    });

    return profilesCollection.doc(uid).snapshots().map(_profileFromSnapshot);
  }
}
