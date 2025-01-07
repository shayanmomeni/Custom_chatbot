import 'package:decent_chatbot/core/constants/color.dart';
import 'package:flutter/material.dart';

class AppThemes {
  ThemeData light({double ratio = 1.0}) => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: AppColors().primaryColor,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        colorScheme:
            ColorScheme.fromSeed(seedColor: AppColors().backGroundColor),
      );
}
