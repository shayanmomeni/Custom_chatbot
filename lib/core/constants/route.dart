import 'package:decent_chatbot/features/assessment/presentation/assessment_screen.dart';
import 'package:decent_chatbot/features/assessment/presentation/binding/assessment_binding.dart';
import 'package:decent_chatbot/features/chat/presentation/binding/chat_binding.dart';
import 'package:decent_chatbot/features/chat/presentation/chat_screen.dart';
import 'package:decent_chatbot/features/login/presentation/binding/login_binding.dart';
import 'package:decent_chatbot/features/login/presentation/login_screen.dart';
import 'package:decent_chatbot/features/self_aspect/presentation/binding/self_aspect_binding.dart';
import 'package:decent_chatbot/features/self_aspect/presentation/self_aspect_screen.dart';
import 'package:decent_chatbot/features/splash/presentation/splash_screen.dart';
import 'package:decent_chatbot/features/welcome/presentation/binding/welcome_binding.dart';
import 'package:decent_chatbot/features/welcome/presentation/welcome_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  final splash = '/';
  final login = '/login';
  final assessment = '/assessment';
  final chat = '/chat';
  final selfAspect = '/selfaspect';
  final welcome = '/welcome';

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
        page: () =>  AssessmentScreen(),
      ),
      GetPage(
        name: chat,
        binding: ChatBinding(),
        page: () => const ChatScreen(),
      ),
      GetPage(
        name: selfAspect,
        binding: SelfAspectBinding(),
        page: () => SelfAspectScreen(),
      ),
      GetPage(
        name: welcome,
        binding: WelcomeBinding(),
        page: () => WelcomeScreen(),
      ),
    ];
  }
}
