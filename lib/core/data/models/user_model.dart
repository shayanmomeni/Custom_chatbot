class User {
  final String? token;
  final String? userId;
  final String? username;
  final String? fullName;
  bool assessmentCompleted;
  bool selfAspectCompleted;
  bool imagesUploaded;
  bool assessmentAspectCompleted; // New flag

  User({
    this.token,
    this.userId,
    this.username,
    this.fullName,
    this.assessmentCompleted = false,
    this.selfAspectCompleted = false,
    this.imagesUploaded = false,
    this.assessmentAspectCompleted = false, // Initialize the new flag
  });

  // Factory method for creating User from API response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      userId: json['userDetails']?['userId'] ?? json['_id'],
      username: json['userDetails']?['username'] ?? json['username'],
      fullName: json['userDetails']?['fullName'] ?? json['fullName'],
      assessmentCompleted: json['assessment_completed'] ?? false,
      selfAspectCompleted: json['self_aspect_completed'] ?? false,
      imagesUploaded:
          json['images_uploaded'] ?? json['imagesUploaded'] ?? false,
      assessmentAspectCompleted:
          json['assessment_aspect_completed'] ?? false, // Parse the new flag
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
      imagesUploaded:
          json['images_uploaded'] ?? json['imagesUploaded'] ?? false,
      assessmentAspectCompleted: json['assessment_aspect_completed'] ?? false,
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
      'images_uploaded': imagesUploaded,
      'assessment_aspect_completed':
          assessmentAspectCompleted, // Include the new flag in JSON output
    };
  }
}
