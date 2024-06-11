import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tegura/models/profile.dart';
import 'package:tegura/models/user.dart';
import 'package:android_id/android_id.dart';
import 'package:tegura/firebase_services/profiledb.dart';

class AuthResult<T> {
  late final T? value;
  late final String? error;
  late final String? warning;
  AuthResult({this.value, this.error, this.warning});
  bool get isSuccess => error == null;
}

class AuthState with ChangeNotifier {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final ProfileService _profileService = ProfileService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late StreamSubscription<User?> _authSubscription;
  final CollectionReference roles =
      FirebaseFirestore.instance.collection('roles');

  UserModel? _userFromFirebaseUser(User usr) {
    return UserModel(usr.email, uid: usr.uid);
  }

  User? _currentUser;
  ProfileModel? _currentProfile;
  bool _isLoggedIn = false;

  AuthState() {
    // Listen to auth state changes
    _authSubscription = _authInstance.authStateChanges().listen((user) {
      if (!isDisposed) {
        _currentUser = user;
        _isLoggedIn = _currentUser != null;
        _currentUser != null ? _updateProfile(_currentUser) : null;
        print('\nAuthStateChanges Current user: $_currentUser');
        print('\nAuthStateChanges Current profile: $_currentProfile');
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
  bool get isLoggedIn => _isLoggedIn;
  ProfileModel? get currentProfile => _currentProfile;

  void setCurrentProfile(ProfileModel? profile) {
    if (_currentProfile != profile) {
      _currentProfile = profile;
      notifyListeners();
    }

    print('\nCurrent profile updated: $_currentProfile');
  }

  void setCurrentUser(User? user) {
    print('\n\nSetting current user: $user');
    if (_currentUser != user) {
      _currentUser = user;
      notifyListeners();
    }
  }

  void setIsLoggedIn(bool isLoggedIn) {
    print('\n\nSetting isLoggedIn: $isLoggedIn');
    if (_isLoggedIn != isLoggedIn) {
      _isLoggedIn = isLoggedIn;
      notifyListeners();
    }
  }

  void _updateProfile(User? user) async {
    if (user != null) {
      _profileService.getCurrentProfileByID(user.uid).listen((profile) {
        // if current profile's lastLoggedInDeviceId is equal to the current device ID
        // then set the current profile to the profile

        getAndroidId().then((value) {
          print(
              '\n\nProfile - Notifier: $profile\nCurrent device ID: ${value}');

          if (profile != null && profile.lastLoggedInDeviceId == value) {
            print('\n\nProfile - Setting current profile: $profile');
            setCurrentProfile(profile);
          }
        });
      });
    }

    setCurrentProfile(null);
  }

  // GET DEVICE ID
  Future<String?> getAndroidId() async {
    try {
      String? androidId = await AndroidId().getId();
      return androidId;
    } catch (e) {
      return null;
    }
  }

  // LOG OUT METHOD
  Future logOut() async {
    DocumentReference profileRef;

    // Get the current user profile reference
    if (currentUser == null) {
      return;
    }

    profileRef = _firestore.collection('profiles').doc(currentUser!.uid);

    // Sign out
    await _authInstance.signOut();

    // Update the lastLoggedInDeviceId to empty string
    await profileRef.update({'lastLoggedInDeviceId': null});

    // Clear the current user and profile
    String? loggedOutUserName = currentProfile?.username;
    setCurrentUser(null);
    setCurrentProfile(null);
    setIsLoggedIn(false);

    return 'Bye $loggedOutUserName!';
  }

  // RESET PASSWORD METHOD
  Future resetPassword(String email) async {
    try {
      await _authInstance.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // LOGIN WITH EMAIL AND PASSWORD METHOD
  Future userLogin(String email, String password) async {
    try {
      UserCredential result = await _authInstance.signInWithEmailAndPassword(
          email: email, password: password);

      print('\n\nLogged in...: $result');

      if (result.user != null && result.user!.uid.isNotEmpty) {
        DocumentReference profileRef =
            _firestore.collection('profiles').doc(result.user?.uid);
        DocumentSnapshot profileSnapshot = await profileRef.get();
        String? deviceId = await getAndroidId();

        if (profileSnapshot.exists) {
          String? prevDeviceId = profileSnapshot.get('lastLoggedInDeviceId');
          await profileRef.update({'lastLoggedInDeviceId': deviceId});

          if (prevDeviceId != '' &&
              prevDeviceId != null &&
              prevDeviceId.isNotEmpty &&
              prevDeviceId != deviceId) {
            return AuthResult(
                error:
                    'Mwemerwe gukoresha konti imwe muri telefoni imwe. Duhamagare kuri 0794033360 tugufashe!');
          }
        }
        return _userFromFirebaseUser(result.user!);
      } else {

        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {

        return AuthResult(error: 'Konti ntibashije kuboneka. Iyandikishe!');
      } else if (e.code == 'wrong-password') {
        
        return AuthResult(error: 'Ijambo banga siryo!');
      } else {

        print("e.toString()) - ${e.toString()}");
      }
    } catch (e) {
      print(e);
      return AuthResult(error: 'Unknown error occurred');
    }
  }

  // REGISTER WITH EMAIL AND PASSWORD METHOD
  Future registerNewUser(String username, String email, String password,
      bool? urStudent, String? regNbr, String? campus) async {
    try {
      // REGISTER WITH EMAIL AND PASSWORD REQUEST - RETURN AUTH RESULT FUTURE
      UserCredential result =
          await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
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
          '',
        );

        return _userFromFirebaseUser(user);
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return AuthResult(error: 'Ijambo banga ntiryujuje ibisabwa!');
      } else if (e.code == 'email-already-in-use') {
        return AuthResult(error: 'Iyi imeyili yarakoreshejwe! Injira!');
      } else {
        print('FirebaseAuthException: $e');
        return AuthResult(error: 'Unknown Firebase Auth error occurred');
      }
    } catch (e) {
      print(e);
      return AuthResult(error: 'Unknown error occurred');
    }
  }

  // toString method
  @override
  String toString() {
    return 'AuthState{currentUser: $_currentUser, currentProfile: $_currentProfile, isLoggedIn: $_isLoggedIn}';
  }
}
