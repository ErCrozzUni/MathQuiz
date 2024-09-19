import 'package:flutter/material.dart';
import 'welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Utilizza ValueNotifier per gestire isDarkMode
  final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: WelcomeScreen(
            isDarkModeNotifier: isDarkModeNotifier,
          ),
        );
      },
    );
  }
}