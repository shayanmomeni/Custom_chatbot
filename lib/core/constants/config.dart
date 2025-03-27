import 'package:decent_chatbot/core/constants/color.dart';
import 'package:decent_chatbot/core/constants/dimens.dart';
import 'package:decent_chatbot/core/constants/local_cache_keys.dart';
import 'package:decent_chatbot/core/constants/route.dart';
import 'package:decent_chatbot/core/constants/theme.dart';

class AppConfig {
  static final AppConfig _singleton = AppConfig._internal();
  factory AppConfig() => _singleton;
  AppConfig._internal();

  // String get baseURL => "http://127.0.0.1:8000/api/v1";
  String get baseURL => "http://10.1.170.83:8888";

  final routes = AppRoutes();
  final dimens = Dimens();
  final colors = AppColors();
  final localCacheKeys = LocalCacheKeys();
  final theme = AppThemes();
}






// exercising at home, going to gym with friends or going to gym alone.
// my lazy self and confident self, my lazy self aspect prefers to stay at home and not meet anyone, while my confident self aspect prefers to go to the gym with friends.
// my lazy side want to stay at home because stayint at home is more comfortable and my confident self wants to go to gym because there is more people in the gym
// my confident self does not want to stay at home because it is boring and my lazy self does not want to go to gym because it is tiring
// my confident self is more important to me because it is the side of me that is more social and outgoing
// This decision aligns with my confident self because it involves taking risks and stepping out of my comfort zone, which requires confidence.
// Going out with friends because it combines physical activity with social interaction,
// yes i think maybe going to a park with exercising tools will satisfy both aspects. my lazy self aspect is okay for going to park bacause it is near and my confident also is agreeable because it can still exercise and socialize