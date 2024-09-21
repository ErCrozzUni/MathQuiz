import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:math_croz_benz/const.dart';

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
    bool isUserLoggedIn = FirebaseAuth.instance.currentUser != null;
    Color backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.blue[800]!;

    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text('Impostazioni', style: whiteTextStyle),
      content: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Modalità Scura', style: whiteTextStylePiccolo),
              value: isDarkMode,
              onChanged: (value) {
                onToggleDarkMode();
                Navigator.of(context).pop();
              },
            ),
            if (isUserLoggedIn)
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                },
                child: const Text('Logout'),
              ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Chiudi'),
        ),
      ],
    );
  }
}
