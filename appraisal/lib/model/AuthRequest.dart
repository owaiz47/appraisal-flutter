class AuthRequest {
  String username;
  String password;

  AuthRequest();
  AuthRequest.json2obj(this.username, this.password);

  factory AuthRequest.fromJson(Map<String, dynamic> json) {
    if (json == null) return AuthRequest();
    return AuthRequest.json2obj(
        json['username'] as String, json['password'] as String);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': this.username,
      'password': this.password
    };
  }
}
