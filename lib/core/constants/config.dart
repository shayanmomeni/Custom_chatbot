import 'package:decent_chatbot/core/constants/color.dart';
import 'package:decent_chatbot/core/constants/dimens.dart';
import 'package:decent_chatbot/core/constants/local_cache_keys.dart';
import 'package:decent_chatbot/core/constants/route.dart';
import 'package:decent_chatbot/core/constants/theme.dart';

class AppConfig {
  static final AppConfig _singleton = AppConfig._internal();
  factory AppConfig() => _singleton;
  AppConfig._internal();

  String get baseURL => "http://127.0.0.1:8000/api/v1";

  final routes = AppRoutes();
  final dimens = Dimens();
  final colors = AppColors();
  final localCacheKeys = LocalCacheKeys();
  final theme = AppThemes();
}
