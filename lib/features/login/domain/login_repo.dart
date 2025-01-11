abstract class LoginRepository {
  Future<Map<String, dynamic>> login(String username, String password);
}