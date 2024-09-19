import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String child;
  final VoidCallback onTap;
  final bool isDarkMode;

  const MyButton({
    Key? key,
    required this.child,
    required this.onTap,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Imposta il colore del pulsante in base a isDarkMode
    Color buttonColor = isDarkMode ? Colors.grey[800]! : Colors.blue[600]!;

    // Regola il colore del pulsante in base al testo del pulsante
    if (child == 'C') {
      buttonColor = Colors.red;
    } else if (child == 'DEL') {
      buttonColor = Colors.red;
    } else if (child == '=') {
      buttonColor = Colors.green;
    }

    // Definisci il colore del testo
    Color textColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(12), // Angoli arrotondati
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
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
