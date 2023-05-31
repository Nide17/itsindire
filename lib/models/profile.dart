// DEFINING USER MODEL TO REPRESENT THE USER
class ProfileModel {
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
  final int? roleId;

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
}
