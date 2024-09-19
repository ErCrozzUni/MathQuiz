import 'package:flutter/material.dart';
import 'package:math_croz_benz/const.dart';
import 'tutorial_dialog.dart';

class SettingsDialog extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const SettingsDialog({
    Key? key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isDarkMode ? Colors.grey[800]! : Colors.blue[800]!,
      content: SizedBox(
        height: 250, // Aumentato per ospitare il nuovo pulsante
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Titolo
            Text(
              'Impostazioni',
              style: whiteTextStyle,
            ),
            // Switch per modalità scura
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Modalità Scura',
                  style: whiteTextStylePiccolo,
                ),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    onToggleDarkMode();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            // Bottone Tutorial
            ElevatedButton(
              onPressed: () {
                // Mostra il dialogo del tutorial
                showDialog(
                  context: context,
                  builder: (context) {
                    return TutorialDialog(isDarkMode: isDarkMode);
                  },
                );
              },
              child: Text('Tutorial'),
            ),
            // Bottone Chiudi
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Chiudi'),
            ),
          ],
        ),
      ),
    );
  }
}