class User {
  final String? token;
  final String? userId;
  final String? username;
  final String? fullName;
  bool assessmentCompleted;
  bool selfAspectCompleted;

  User({
    this.token,
    this.userId,
    this.username,
    this.fullName,
    this.assessmentCompleted = false,
    this.selfAspectCompleted = false,
  });

  // Factory method for creating User from API response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      userId: json['userDetails']?['userId'],
      username: json['userDetails']?['username'],
      fullName: json['userDetails']?['fullName'],
      assessmentCompleted: json['assessment_completed'] ?? false,
      selfAspectCompleted: json['self_aspect_completed'] ?? false,
    );
  }

  // Factory method for creating User from local cache
  factory User.fromLocalCacheJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      userId: json['userId'],
      username: json['username'],
      fullName: json['fullName'],
      assessmentCompleted: json['assessment_completed'] ?? false,
      selfAspectCompleted: json['self_aspect_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'username': username,
      'fullName': fullName,
      'assessment_completed': assessmentCompleted,
      'self_aspect_completed': selfAspectCompleted,
    };
  }
}
