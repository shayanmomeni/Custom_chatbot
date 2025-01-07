class User {
  final String? token;

  User({
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['access_token'],
    );
  }

  factory User.fromLocalCacheJson(
    Map<String, dynamic> json, {
    String? token,
    String? refreshToken,
  }) {
    return User(
      token: token ?? json['access_token'],
    );
  }
}
