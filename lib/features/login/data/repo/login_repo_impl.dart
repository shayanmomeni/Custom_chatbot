import 'package:decent_chatbot/core/data/services/auth_service.dart';
import '../../domain/login_repo.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginService _service;

  LoginRepositoryImpl(this._service);

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    return await _service.login(username, password);
  }
}
