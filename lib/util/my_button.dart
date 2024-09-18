import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String child;
  final VoidCallback onTap;

  const MyButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determina se la modalità scura è attiva
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Imposta il colore predefinito del pulsante
    Color buttonColor = isDarkMode ? Colors.grey[800]! : Colors.blue[600]!;

    // Regola il colore del pulsante in base al testo del pulsante
    if (child == 'C') {
      buttonColor = Colors.green;
    } else if (child == 'DEL') {
      buttonColor = Colors.red;
    } else if (child == '=') {
      buttonColor = Colors.indigo;
    }

    // Definisci il colore del testo
    Color textColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(12), // Angoli arrotondati
          ),
          child: Center(
            child: Text(
              child,
              style: TextStyle(
                fontSize: 24,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
