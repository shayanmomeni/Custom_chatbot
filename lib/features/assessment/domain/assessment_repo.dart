import 'package:decent_chatbot/core/data/models/assessment_request_model.dart';

abstract class AssessmentRepository {
  Future<void> saveAssessment(AssessmentRequest request);
}