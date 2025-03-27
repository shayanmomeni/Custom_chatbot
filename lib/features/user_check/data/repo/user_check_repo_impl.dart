import 'package:decent_chatbot/core/data/models/user_model.dart';
import 'package:decent_chatbot/core/data/services/user_service.dart';

import '../../domain/user_check_repo.dart';

class UserCheckRepositoryImpl implements UserCheckRepository {
  final UserService userService = UserService();

  @override
  Future<User?> fetchUserStatus(String userId) async {
    try {
      final data = await userService.fetchUser(userId);
      return User.fromJson(data);
    } catch (e) {
      throw Exception("Error fetching user status: $e");
    }
  }
}
