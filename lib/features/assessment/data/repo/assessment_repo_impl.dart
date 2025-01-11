import 'package:decent_chatbot/core/data/models/assessment_request_model.dart';
import 'package:decent_chatbot/core/data/services/assessment_service.dart';

import '../../domain/assessment_repo.dart';

class AssessmentRepositoryImpl implements AssessmentRepository {
  final AssessmentService _service;

  AssessmentRepositoryImpl(this._service);

  @override
  Future<void> saveAssessment(AssessmentRequest request) {
    return _service.saveAssessment(request);
  }
}
