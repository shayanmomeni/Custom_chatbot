import 'package:decent_chatbot/core/utils/enum.dart';

String toCamelCase(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

extension UserStatusExtensionFeedback on UserStatus {
  int toLocalCacheInt() {
    switch (this) {
      case UserStatus.loggedIn:
        return 1;
      case UserStatus.loggedOut:
        return 2;
    }
  }
}

extension UserStatusExtension on int? {
  UserStatus toUserStatus() {
    switch (this) {
      case null:
        return UserStatus.loggedOut;
      case 1:
        return UserStatus.loggedIn;
      case 2:
        return UserStatus.loggedOut;
      default:
        return UserStatus.loggedOut;
    }
  }
}
