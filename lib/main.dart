import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/pages/main_page.dart';
import 'package:to_do_list/theme/dark_theme.dart';
import 'package:to_do_list/theme/light_theme.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState(); // _ belgisi olib tashlandi

  // Mana shu metodni qo'shing:
  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppState extends State<MyApp> { // _ belgisi olib tashlandi
  ThemeMode themeMode1 = ThemeMode.light;

  void changeTheme(ThemeMode themeMode){
    setState(() {
      themeMode1 = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode1,
      home:  HomePage(),
    );
  }
}
