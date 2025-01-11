import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientation
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  print("Initializing local cache...");
  await AppRepo().localCache.init();
  print("Local cache initialized successfully!");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          getPages: AppConfig().routes.pages,
          initialRoute: AppConfig().routes.splash,
          theme: AppConfig().theme.light(),
        ),
      ),
    );
  }
}
