class UserModel {
  final String email;
  final String fName;
  final String icNum;
  final String idNum;
  final String lName;
  final String password;
  final String profilePic;

  const UserModel(
      {required this.email,
      required this.fName,
      required this.icNum,
      required this.idNum,
      required this.lName,
      required this.password,
      required this.profilePic});

  toJson() {
    return {
      "email": email,
      "fName": fName,
      "icNum": icNum,
      "idNum": idNum,
      "lName": lName,
      "password": password,
      "profilePice": profilePic,
    };
  }
}
