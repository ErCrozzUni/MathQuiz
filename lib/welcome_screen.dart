import 'package:flutter/material.dart';
import 'package:math_croz_benz/util/login_dialog.dart';
import 'const.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatefulWidget {
  final ValueNotifier<bool> isDarkModeNotifier;

  const WelcomeScreen({Key? key, required this.isDarkModeNotifier}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(isDarkModeNotifier: widget.isDarkModeNotifier),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isDarkModeNotifier,
      builder: (context, isDarkMode, _) {
        Color backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.blue[400]!;
        Color buttonColor = isDarkMode ? Colors.grey[800]! : Colors.blue[800]!;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Benvenuto a Math Quiz!', style: whiteTextStyle),
                const SizedBox(height: 20),
                // Pulsante per iniziare il gioco
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: startGame,
                  child: Text(
                    'Inizia',
                    style: whiteTextStylePiccolo,
                  ),
                ),
                const SizedBox(height: 10),
                // Pulsante Login
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: () {
                    // Mostra il dialogo di login
                    showDialog(
                      context: context,
                      builder: (context) {
                        return LoginDialog(isDarkMode: isDarkMode);
                      },
                    );
                  },
                  child: Text(
                    'Login',
                    style: whiteTextStylePiccolo,
                  ),
                ),
                const SizedBox(height: 10),
                // Pulsante Logout (visibile solo se l'utente è autenticato)
                if (FirebaseAuth.instance.currentUser != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      setState(() {}); // Aggiorna lo stato per nascondere il pulsante Logout
                    },
                    child: Text(
                      'Logout',
                      style: whiteTextStylePiccolo,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
