import 'package:flutter/material.dart';
import 'swatches.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: primarySwatch,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: primarySwatch,
      accentColor: secondarySwatch,
      errorColor: errorSwatch,
    ).copyWith(
      secondary: secondarySwatch,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onError: Colors.white,
      onSurface: Colors.black,
    ),
  );
}
