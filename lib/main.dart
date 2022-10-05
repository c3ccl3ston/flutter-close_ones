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
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'Close Ones',
        restorationScopeId: "root",
        home: const Homepage(title: 'Close Ones'),
        theme: ThemeData(
            colorScheme: lightColorScheme ??
                ColorScheme.fromSeed(seedColor: const Color(0xFF4267b2)),
            useMaterial3: true),
        darkTheme: ThemeData(
            colorScheme: darkColorScheme ??
                ColorScheme.fromSeed(
                    seedColor: const Color.fromARGB(255, 24, 27, 32),
                    brightness: Brightness.dark),
            useMaterial3: true),
        themeMode: ThemeMode.system,
      );
    });
  }
}
