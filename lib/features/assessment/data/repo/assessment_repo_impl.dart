import 'package:decent_chatbot/core/data/services/assessment_service.dart';

import '../../domain/assessment_repo.dart';

class AssessmentRepositoryImpl implements AssessmentRepository {
  final AssessmentService _service;

  AssessmentRepositoryImpl(this._service);

  @override
  Future<void> saveAssessment(String userId, List<String> answers) {
    return _service.saveAssessment(userId, answers);
  }
}
