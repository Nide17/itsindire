import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/models/profile.dart';
import 'package:itsindire/models/user.dart';
import 'package:itsindire/firebase_services/profiledb.dart';
import 'package:itsindire/main.dart';

class AuthState with ChangeNotifier {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final ProfileService _profileService = ProfileService();
  late StreamSubscription<User?> _authSubscription;
  StreamSubscription<ProfileModel?>? _profileSubscription;

  final CollectionReference profilesCollection =
      FirebaseFirestore.instance.collection('profiles');
  final CollectionReference rolesCollection =
      FirebaseFirestore.instance.collection('roles');
  final CollectionReference paymentsCollection =
      FirebaseFirestore.instance.collection('payments');
  final CollectionReference progressCollection =
      FirebaseFirestore.instance.collection('progresses');
  final CollectionReference isuzumaScoresCollection =
      FirebaseFirestore.instance.collection('scores');

  UserModel? _userFromFirebaseUser(User usr) {
    return UserModel(uid: usr.uid, usr.email, usr.displayName);
  }

  User? _currentUser;
  ProfileModel? _currentProfile;

  AuthState() {
    _authSubscription = _authInstance.authStateChanges().listen((user) {
      if (!isDisposed) {
        _currentUser = user;
        if (_currentUser != null) {
          _updateProfile(_currentUser);
        }
        notifyListeners();
      }
    });
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _authSubscription.cancel();
    _isDisposed = true;
    super.dispose();
  }

  bool get isDisposed => _isDisposed;
  User? get currentUser => _currentUser;
  ProfileModel? get currentProfile => _currentProfile;

  void setCurrentProfile(ProfileModel? profile) {
    if (_currentProfile != profile) {
      _currentProfile = profile;
      notifyListeners();
    }
  }

  void setCurrentUser(User? user) {
    if (_currentUser != user) {
      _currentUser = user;
      notifyListeners();
    }
  }

  void _updateProfile(User? user) async {
    // Cancel any previous subscription to avoid multiple listeners
    await _profileSubscription?.cancel();

    if (user != null) {
      try {
        _profileSubscription =
            _profileService.getCurrentProfileByID(user.uid).listen((profile) {
          setCurrentProfile(profile);
        });
      } catch (e) {
        print('Failed to update profile: $e');
      }
    } else {
      setCurrentProfile(null);
    }
  }

  // LOG OUT METHOD
  Future logOut() async {
    try {
      String? loggedOutUserName =
          currentProfile?.username != null && currentProfile?.username != ''
              ? currentProfile?.username
              : currentUser?.email;

      // Sign out
      await _authInstance.signOut();

      // Clear sessionID in the profile
      if (currentProfile != null) {
        await profilesCollection
            .doc(currentProfile?.uid)
            .update({'sessionID': null});
      }

      // Clear the current user and profile
      setCurrentUser(null);
      setCurrentProfile(null);

      return 'Bye $loggedOutUserName!';
    } catch (e) {
      print('Failed to log out: $e');
      return 'Failed to log out';
    }
  }

  // RESET PASSWORD METHOD
  Future resetPassword(String email) async {
    try {
      await _authInstance.sendPasswordResetEmail(email: email);
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User not found';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email';
      } else {
        return 'Failed to send reset email';
      }
    } catch (e) {
      return 'An unknown error occurred';
    }
  }

  Future userLogin(String email, String password) async {
    try {
      // Search for the user profile by email
      QuerySnapshot querySnapshot =
          await profilesCollection.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isEmpty) {
        return ReturnedResult(
          error: 'Konti ntibashije kuboneka. Iyandikishe!',
        );
      }

      String? sessionIdentity = querySnapshot.docs.first.get('sessionID');
      if (sessionIdentity != '' && sessionIdentity != null) {
        return ReturnedResult(
          error:
              'Mwemerewe gukoresha konti imwe muri telefoni imwe. Duhamagare kuri 0794033360 tugufashe!',
        );
      }

      UserCredential result = await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null || result.user!.uid.isEmpty) {
        return ReturnedResult(
            error:
                'Kwinjira ntibikunda. Duhamagare kuri 0794033360 tugufashe!');
      }

      // Update sessionID in profiles collection
      String sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      await profilesCollection.doc(result.user?.uid).set({
        'email': email,
        'sessionID': sessionId,
      }, SetOptions(merge: true));

      // Update the current user's payment data
      await paymentsCollection.doc(result.user?.uid).get().then((value) {
        if (value.exists &&
            value.get('ifatabuguziID') == 'UGl3ahnKZdVrBVTItht7' &&
            value.get('endAt') == null) {
          paymentsCollection.doc(result.user?.uid).update({
            'createdAt': DateTime.now(),
            'endAt': DateTime.now().add(Duration(minutes: 30)),
            'isApproved': true,
          });
        }
      });

      String username = result.user!.displayName ??
          querySnapshot.docs.first.get('username') ??
          email;
      return ReturnedResult(
          value: _userFromFirebaseUser(result.user!),
          successMessage: 'Ikaze ${username}!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ReturnedResult(error: 'Konti ntibashije kuboneka. Iyandikishe!');
      } else if (e.code == 'wrong-password') {
        return ReturnedResult(error: 'Ijambo banga siryo!');
      } else if (e.code == 'invalid-email') {
        return ReturnedResult(error: 'Invalid email format');
      } else if (e.code == 'user-disabled') {
        return ReturnedResult(error: 'User account is disabled');
      } else {
        return ReturnedResult(error: 'Ntibikunze, reba ko ufite interineti!');
      }
    } catch (e) {
      print("\n\n\n Error occured: $e \n\n\n");
      return ReturnedResult(error: 'Habayeho ikosa, ibyo musabye ntibyakunda.');
    }
  }

  // REGISTER WITH EMAIL AND PASSWORD METHOD
  Future registerNewUser(String username, String email, String password,
      bool? urStudent, String? regNbr, String? campus) async {
    try {
      UserCredential result =
          await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      result.user?.updateDisplayName(username);

      User? user = result.user;

      if (user != null) {
        await profilesCollection.doc(user.uid).set({
          'uid': user.uid,
          'username': username,
          'email': email,
          'urStudent': urStudent,
          'regNumber': regNbr,
          'campus': campus,
          'roleId': rolesCollection.doc('1'),
          'sessionID': '',
        });

        // save trial payment
        await paymentsCollection.doc(user.uid).set({
          'ifatabuguziID': 'UGl3ahnKZdVrBVTItht7',
          'userId': user.uid,
          'igiciro': 0,
          'createdAt': null,
          'endAt': null,
          'isApproved': true,
          'phone': null,
        });

        return ReturnedResult(
          value: 'Registered successfully, welcome!',
        );
      } else {
        return ReturnedResult(error: 'Registration failed.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ReturnedResult(error: 'Ijambo banga ntiryujuje ibisabwa!');
      } else if (e.code == 'email-already-in-use') {
        return ReturnedResult(error: 'Iyi imeyili yarakoreshejwe! Injira!');
      } else {
        return ReturnedResult(error: 'Unknown Firebase Auth error occurred');
      }
    } catch (e) {
      return ReturnedResult(error: 'Unknown error occurred');
    }
  }

  // Delete user account
  Future deleteAccount(String userId, String email, String password) async {
    try {
      // re-authenticate user before deleting account
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await _authInstance.currentUser?.reauthenticateWithCredential(credential);
      print('Deleting user account: ${userId}');

      // delete payments
      await paymentsCollection.doc(userId).delete();
      print('Payments deleted');

      // delete profile
      await profilesCollection.doc(userId).delete();
      print('\n\nProfile deleted');

      // delete scores
      await isuzumaScoresCollection
          .where('takerID', isEqualTo: userId)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
      });
      print('Scores deleted');

      // delete progresses
      await progressCollection
          .where('userId', isEqualTo: userId)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
      });
      print('Progresses deleted');

      // delete account
      await _authInstance.currentUser?.delete();
      print('User account deleted');
      return ReturnedResult(
        successMessage: 'Konti yawe yasibwe!',
      );
    } catch (e) {
      print('\n\n\nFailed to delete user account: $e');
      return ReturnedResult(
        error: 'Gusiba konti ntibikunda!',
      );
    }
  }

  // toString method
  @override
  String toString() {
    return 'AuthState{currentUser: $_currentUser, currentProfile: $_currentProfile, isDisposed: $_isDisposed, authInstance: $_authInstance}';
  }
}
