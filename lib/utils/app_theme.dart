import 'package:chat_app/utils/app_color.dart';
import 'package:flutter/material.dart';

TextStyle commonTextStyle = const TextStyle(
  color: AppColor.white,
);
TextStyle commonLabelStyle = const TextStyle(
  color: AppColor.grey,
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColor.black,
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
  ),
  textTheme: TextTheme(
    headlineLarge: commonTextStyle,
    headlineMedium: commonTextStyle,
    headlineSmall: commonTextStyle,
    bodyLarge: commonTextStyle,
    bodyMedium: commonTextStyle,
    bodySmall: commonTextStyle,
    labelLarge: commonTextStyle,
    labelMedium: commonTextStyle,
    labelSmall: commonTextStyle,
  ).apply(
    displayColor: AppColor.white,
    bodyColor: AppColor.white,
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStatePropertyAll(
        TextStyle(fontSize: 17),
      ),
      backgroundColor: MaterialStatePropertyAll(Colors.blueAccent),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: commonLabelStyle,
    hintStyle: commonLabelStyle,
    border: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColor.white,
      ),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColor.white,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade600,
      ),
    ),
  ),
);
