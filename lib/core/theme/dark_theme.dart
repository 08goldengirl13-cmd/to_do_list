import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,

  colorScheme: const ColorScheme.dark(
    primary: Color(0xffffffff),
    secondary: Color(0xffffffff),
    surface: Color(0xff10232F),
    error: Color(0xffEF5350),

    onPrimary: Color(0xff081723),
    onSecondary: Color(0xffffffff),
    onSurface: Color(0xffffffff),
    onError: Color(0xffffffff),
  ),

  scaffoldBackgroundColor: Color(0xff081723),
);