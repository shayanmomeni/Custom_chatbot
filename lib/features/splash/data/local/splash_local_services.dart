
import 'package:decent_chatbot/core/constants/local_cache_keys.dart';
import 'package:decent_chatbot/core/data/local_cache/local_cache_helper.dart';

class SplashLocalServices extends LocalCacheHelper {
  Future<dynamic> fetchUser() async {
    return await read(LocalCacheKeys().userObject);
  }
}
