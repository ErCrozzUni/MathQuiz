import 'package:flutter/material.dart';
import 'package:math_croz_benz/const.dart';

class TutorialDialog extends StatelessWidget {
  final bool isDarkMode;

  const TutorialDialog({
    Key? key,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.blue[800]!;
    Color textColor = Colors.white;

    String tutorialText = '''
Benvenuto in Math Quiz!

Il gioco consiste nel risolvere operazioni matematiche nel minor tempo possibile. Ci sono 5 livelli:

- Livello 1: Addizioni con numeri ad una cifra (x + x)
- Livello 2: Addizioni con numeri a due cifre (xx + xx)
- Livello 3: Sottrazioni con numeri ad una cifra (x - x)
- Livello 4: Sottrazioni con numeri a due cifre (xx - xx)
- Livello 5: Moltiplicazioni tra un numero a due cifre e uno ad una cifra (xx × x)

Il tuo punteggio aumenta in base alla velocità con cui rispondi correttamente. Più veloce sei, più punti ottieni!

Ogni volta che raggiungi un determinato punteggio, passerai al livello successivo.

Buon divertimento!
''';

    return AlertDialog(
      backgroundColor: backgroundColor,
      content: SingleChildScrollView(
        child: Text(
          tutorialText,
          style: whiteTextStylePiccolo.copyWith(color: textColor),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Chiudi'),
        ),
      ],
    );
  }
}
