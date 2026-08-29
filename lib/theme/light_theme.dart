import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,

  colorScheme: const ColorScheme.light(
    primary: Color(0xff081723),
    secondary: Color(0xff081723),
    surface: Color(0xffffffff),
    error: Color(0xffd32f2f),

    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xff081723),
    onError: Colors.white,
  ),

  scaffoldBackgroundColor: Colors.white,
);