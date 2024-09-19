import 'package:flutter/material.dart';
import 'package:math_croz_benz/util/tutorial_dialog.dart';
import 'home_page.dart';
import 'const.dart';

class WelcomeScreen extends StatelessWidget {
  final ValueNotifier<bool> isDarkModeNotifier;

  const WelcomeScreen({
    Key? key,
    required this.isDarkModeNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, _) {
        // Definisci i colori in base alla modalità
        Color backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.blue[400]!;
        Color buttonColor = isDarkMode ? Colors.grey[800]! : Colors.blue[600]!;
        Color textColor = Colors.white;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Aggiungi il logo qui
                Image.asset(
                  'assets/logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 50),
                // Pulsante Inizia a Giocare
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: () {
                    // Naviga alla HomePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          isDarkModeNotifier: isDarkModeNotifier,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Inizia a Giocare',
                    style: whiteTextStylePiccolo,
                  ),
                ),
                const SizedBox(height: 20),
                // Pulsante Tutorial
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: () {
                    // Mostra il dialogo del tutorial
                    showDialog(
                      context: context,
                      builder: (context) {
                        return TutorialDialog(isDarkMode: isDarkMode);
                      },
                    );
                  },
                  child: Text(
                    'Tutorial',
                    style: whiteTextStylePiccolo,
                  ),
                ),
                const SizedBox(height: 20),
                // Pulsante Cambia Modalità
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: () {
                    isDarkModeNotifier.value = !isDarkModeNotifier.value;
                  },
                  child: Text(
                    'Cambia Modalità',
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
