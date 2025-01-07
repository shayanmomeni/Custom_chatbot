import 'package:decent_chatbot/features/splash/data/local/splash_local_services.dart';

import '../../domain/splash_repo.dart';

class SplashRepositoryImpl implements SplashRepository {
  @override
  Future fetchUserFromLocalCache() async {
    return await SplashLocalServices().fetchUser();
  }
}
