abstract class SelfAspectRepository {
  /// Saves the selected self-aspects for a user.
  ///
  /// Takes [userId] and a list of [aspects] as input.
  /// Returns a map containing the response data from the backend.
  Future<Map<String, dynamic>> saveSelfAspects(
      String userId, List<String> aspects);
}
