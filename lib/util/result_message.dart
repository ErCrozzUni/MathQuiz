import 'package:flutter/material.dart';
import 'package:math_croz_benz/const.dart';

class ResultMessage extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String message;
  final bool isDarkMode;

  const ResultMessage({
    Key? key,
    required this.message,
    required this.onTap,
    required this.icon,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.blue[800]!;

    return AlertDialog(
      backgroundColor: backgroundColor,
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Risultato
            Text(
              message,
              style: whiteTextStyle,
              textAlign: TextAlign.center,
            ),
            // Bottone per la prossima domanda
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700]! : Colors.blue[400],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
