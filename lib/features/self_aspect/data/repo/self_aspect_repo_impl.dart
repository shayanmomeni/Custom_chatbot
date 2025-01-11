import 'package:decent_chatbot/core/data/services/self_aspect_service.dart';

import '../../domain/self_aspect_repo.dart';

class SelfAspectRepositoryImpl implements SelfAspectRepository {
  final SelfAspectService _service = SelfAspectService();

  @override
  Future<Map<String, dynamic>> saveSelfAspects(
      String userId, List<String> aspects) async {
    return await _service.saveSelfAspects(userId, aspects);
  }
}
