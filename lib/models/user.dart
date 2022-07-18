class User {
  User(this.userName, this.password, this.email,
      {this.id,
      this.firstName,
      this.lastName,
      this.avatar,
      this.phoneNumber,
      this.about,
      this.website,

      required this.key,
      // this.accessToken,
      // this.refreshToken
      });


  String userName;
  String password;
  String email;
  int? id;
  String? firstName;
  String? lastName;
  String? avatar;
  String? phoneNumber;
  String? about;
  String? website;

  String key;
  // String? accessToken;
  // String? refreshToken;
}
