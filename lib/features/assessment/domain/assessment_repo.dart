abstract class AssessmentRepository {
  Future<void> saveAssessment(String userId, List<String> answers);
}
