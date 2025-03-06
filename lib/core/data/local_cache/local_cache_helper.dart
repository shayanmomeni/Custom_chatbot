// lib/core/data/local_cache/local_cache_helper.dart
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:get_storage/get_storage.dart';

class LocalCacheHelper {
  final storage = GetStorage(AppConfig().localCacheKeys.databaseName);

  /// Initialize GetStorage for local cache
  Future<void> init() async {
    print(
        "Initializing GetStorage with database: ${AppConfig().localCacheKeys.databaseName}");
    await GetStorage.init(AppConfig().localCacheKeys.databaseName);
  }

  /// Write data to the cache
  Future<void> write(String key, dynamic value) async {
    print("Saving to local cache: Key = $key, Value = $value");
    await storage.write(key, value);
  }

  /// Read data from the cache
  T? read<T>(String key) {
    final value = storage.read<T>(key);
    print("Reading from local cache: Key = $key, Value = $value");
    return value;
  }

  /// Clear all data from the cache
  Future<void> clear() async {
    print("Clearing all local cache data.");
    await storage.erase();
  }
}
