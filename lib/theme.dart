import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Nunito',
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Nunito',
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
