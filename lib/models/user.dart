// DEFINING PROFILE MODEL TO REPRESENT THE USER
class UserModel {
  final String uid; // UNIQUE ID OF THE USER - FROM FIREBASE
  final String? email; // UNIQUE EMAIL OF THE USER - FROM FIREBASE

  // CONSTRUCTOR
  UserModel(this.email, {required this.uid});

  // TO STRING
  @override
  String toString() {
    return "UserModel {id: $uid, email: $email}";
  }
}
