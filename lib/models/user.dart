class User {
  String email;
  String user;
  String pass;

  User({required this.email, required this.pass, required this.user});

  Map<String, dynamic> toJson() {
    return {'email': email, 'user': user, 'pass': pass};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(email: json['email'], pass: json['pass'], user: json['user']);
  }
}
