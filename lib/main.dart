import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'welcome_screen.dart';

void main() async {
  debugPrint("1");
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("2");
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  debugPrint("3");
  runApp(MyApp());
  debugPrint("4");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, _) {
        return MaterialApp(
          title: 'Math Quiz',
          debugShowCheckedModeBanner: false,
          theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: WelcomeScreen(
            isDarkModeNotifier: isDarkModeNotifier,
          ),
        );
      },
    );
  }
}
