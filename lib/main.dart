import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'views/homepage.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _defaultLightColorScheme =
      ColorScheme.fromSeed(seedColor: const Color(0xFF4267B2));

  static final _defaultDarkColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4267B2),
      brightness: Brightness.dark,
      primaryContainer: const Color(0xFF555555));

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'Close Ones',
        restorationScopeId: "root",
        home: const Homepage(title: 'Close Ones'),
        theme: ThemeData(
            colorScheme: lightColorScheme ?? _defaultLightColorScheme,
            useMaterial3: true),
        darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
            useMaterial3: true),
        themeMode: ThemeMode.system,
      );
    });
  }
}
