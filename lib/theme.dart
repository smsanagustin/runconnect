import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = const Color.fromRGBO(146, 211, 231, 1);
  static Color primaryAccent = const Color.fromRGBO(24, 75, 108, 1);
  static Color secondaryColor = const Color.fromRGBO(231, 166, 146, 1);
  // static Color secondaryAccent = const Color.fromRGBO(35, 35, 35, 1);
  // static Color titleColor = const Color.fromRGBO(200, 200, 200, 1);
  static Color textColor = const Color.fromRGBO(24, 75, 108, 1);
  static Color successColor = const Color.fromRGBO(9, 149, 110, 1);
  static Color errorColor = const Color.fromRGBO(222, 90, 78, 1);
  static Color highlightColor = const Color.fromRGBO(212, 172, 13, 1);
}

ThemeData primaryTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
  fontFamily: 'Cabin',

  // scaffold color
  scaffoldBackgroundColor: AppColors.primaryAccent,

  // app bar color
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.secondaryColor,
    foregroundColor: AppColors.textColor,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
  ),

  // text theme
  textTheme: TextTheme(
    headlineMedium: TextStyle(
      color: AppColors.textColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    ),
    bodyMedium: TextStyle(
      color: AppColors.textColor,
      fontSize: 16,
      letterSpacing: 1,
    ),
    titleMedium: TextStyle(
      color: AppColors.textColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
  ),
);
