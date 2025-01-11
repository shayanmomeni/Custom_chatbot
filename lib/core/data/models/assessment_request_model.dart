class AssessmentRequest {
  final String userId;
  final List<List<String>> answers;

  AssessmentRequest({required this.userId, required this.answers});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'answers': answers,
    };
  }
}
