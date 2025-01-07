import 'package:decent_chatbot/features/assessment/presentation/assessment_screen.dart';
import 'package:decent_chatbot/features/assessment/presentation/binding/assessment_binding.dart';
import 'package:decent_chatbot/features/chat/presentation/binding/chat_binding.dart';
import 'package:decent_chatbot/features/chat/presentation/chat_screen.dart';
import 'package:decent_chatbot/features/login/presentation/binding/login_binding.dart';
import 'package:decent_chatbot/features/login/presentation/login_screen.dart';
import 'package:decent_chatbot/features/splash/presentation/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  final splash = '/';
  final login = '/login';
  final assessment = '/assessment';
  final chat = '/chat';

  List<GetPage> get pages {
    return [
      GetPage(
        name: splash,
        page: () => SplashScreen(),
      ),
      GetPage(
        name: login,
        binding: LoginBinding(),
        page: () => const LoginScreen(),
      ),
      GetPage(
        name: assessment,
        binding: AssessmentBinding(),
        page: () => const AssessmentScreen(),
      ),
      GetPage(
        name: chat,
        binding: ChatBinding(),
        page: () => const ChatScreen(),
      ),
    ];
  }
}
