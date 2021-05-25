import 'package:appraisal/helpers/CleanJson.dart';

class User {
  int _id;
  String _username;
  String _password;
  String _email;
  String _fullname;
  String _dp;
  bool _admin;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  String get email => _email;

  bool get admin => _admin;

  set admin(bool value) {
    _admin = value;
  }

  String get dp => _dp;

  set dp(String value) {
    _dp = value;
  }

  String get fullname => _fullname;

  set fullname(String value) {
    _fullname = value;
  }

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  User();
  User.json2obj(this._id, this._username, this._email, this._fullname, this._dp,
      this._admin);

  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) return new User();
    return User.json2obj(
      CleanJson.cleanJsonInteger('id', json),
      json['username'] as String,
      json['email'] as String,
      json['fullname'] as String,
      json['dp'] as String,
      CleanJson.cleanJsonBool('admin', json),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'username': this.username,
        'fullname': this.fullname,
        'dp': this.dp,
        'email': this.email,
        'admin': this.admin,
        'password': this.password,
      };
}
