import 'package:decent_chatbot/core/data/models/user_model.dart';

abstract class UserCheckRepository {
  Future<User?> fetchUserStatus(String userId);
}
