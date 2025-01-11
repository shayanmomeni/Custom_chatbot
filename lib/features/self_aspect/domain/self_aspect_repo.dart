abstract class SelfAspectRepository {
  /// Fetches the user's assessment answers
  Future<List<String>> fetchUserAssessment(String userId);

  /// Saves the user's selected self-aspects
  Future<Map<String, dynamic>> saveSelfAspects(
      String userId, List<String> aspects);
}
