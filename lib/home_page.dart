import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_croz_benz/util/my_button.dart';
import 'package:math_croz_benz/util/result_message.dart';
import 'package:math_croz_benz/util/settings_dialog.dart';
import 'const.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<bool> isDarkModeNotifier;

  const HomePage({
    Key? key,
    required this.isDarkModeNotifier,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista tasti tastierino
  List<String> numberPad = [
    '7',
    '8',
    '9',
    'C',
    '4',
    '5',
    '6',
    'DEL',
    '1',
    '2',
    '3',
    '=',
    '0',
  ];

  // Numeri per la domanda
  int numberA = 1;
  int numberB = 1;

  // Risposta dell'utente
  String userAnswer = '';

  // Punteggio
  int score = 0;
  int highScore = 0;

  // Livello corrente (inizia da 1)
  int currentLevel = 1; // Livelli da 1 a 5

  // Generatore di numeri casuali
  var randomNumber = Random();

  // Stopwatch per misurare il tempo di risposta
  Stopwatch stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  // Utente preme un bottone
  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        // Risposta utente data
        checkResult();
      } else if (button == 'C') {
        // Pulsante clear
        userAnswer = '';
      } else if (button == 'DEL') {
        // Pulsante delete
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      } else if (userAnswer.length < 3) {
        userAnswer += button;
      }
    });
  }

  // Aggiorna il livello in base al punteggio
  void updateLevel() {
    if (score < 50) {
      currentLevel = 1;
    } else if (score < 120) {
      currentLevel = 2;
    } else if (score < 200) {
      currentLevel = 3;
    } else if (score < 300) {
      currentLevel = 4;
    } else {
      currentLevel = 5;
    }
  }

  // Check risposta corretta
  void checkResult() {
    int correctAnswer;

    // Calcola la risposta corretta in base al livello
    switch (currentLevel) {
      case 1:
        correctAnswer = numberA + numberB;
        break;
      case 2:
        correctAnswer = numberA + numberB;
        break;
      case 3:
        correctAnswer = numberA - numberB;
        break;
      case 4:
        correctAnswer = numberA - numberB;
        break;
      case 5:
        correctAnswer = numberA * numberB;
        break;
      default:
        correctAnswer = numberA + numberB;
    }

    if (correctAnswer == int.parse(userAnswer)) {
      stopwatch.stop(); // Ferma il cronometro
      double timeTaken = stopwatch.elapsedMilliseconds / 1000.0; // Tempo in secondi

      // Modifica del calcolo del punteggio
      int baseScore = 10; // Punteggio base per ogni risposta corretta
      int timeBonus = max(0, ((15 - timeTaken) * 2).ceil()); // Bonus tempo aumentato

      setState(() {
        score += baseScore + timeBonus; // Aggiorna il punteggio

        if (score > highScore) {
          highScore = score;
        }
        updateLevel(); // Aggiorna il livello in base al nuovo punteggio
      });

      showDialog(
        context: context,
        builder: (context) {
          return ValueListenableBuilder<bool>(
            valueListenable: widget.isDarkModeNotifier,
            builder: (context, isDarkMode, _) {
              return ResultMessage(
                message: 'Corretto\n+${baseScore + timeBonus} punti',
                onTap: goToNextQuestion,
                icon: Icons.arrow_forward,
                isDarkMode: isDarkMode, // Passa isDarkMode
              );
            },
          );
        },
      );
    } else {
      stopwatch.stop(); // Ferma il cronometro
      setState(() {
        score = 0; // Reimposta il punteggio
        currentLevel = 1; // Reimposta il livello
      });
      showDialog(
        context: context,
        builder: (context) {
          return ValueListenableBuilder<bool>(
            valueListenable: widget.isDarkModeNotifier,
            builder: (context, isDarkMode, _) {
              return ResultMessage(
                message: 'Risposta Errata',
                onTap: goBackToQuestion,
                icon: Icons.rotate_left,
                isDarkMode: isDarkMode, // Passa isDarkMode
              );
            },
          );
        },
      );
    }
  }

  // Genera una nuova domanda in base al livello
  void generateQuestion() {
    // Avvia il cronometro
    stopwatch.reset();
    stopwatch.start();

    switch (currentLevel) {
      case 1:
      // Livello 1: addizione a una cifra
        numberA = randomNumber.nextInt(9) + 1; // Evita lo zero
        numberB = randomNumber.nextInt(9) + 1;
        break;
      case 2:
      // Livello 2: addizione a due cifre
        numberA = randomNumber.nextInt(90) + 10;
        numberB = randomNumber.nextInt(90) + 10;
        break;
      case 3:
      // Livello 3: sottrazione a una cifra
        numberA = randomNumber.nextInt(9) + 1;
        numberB = randomNumber.nextInt(9) + 1;
        if (numberB > numberA) {
          int temp = numberA;
          numberA = numberB;
          numberB = temp;
        }
        break;
      case 4:
      // Livello 4: sottrazione a due cifre
        numberA = randomNumber.nextInt(90) + 10;
        numberB = randomNumber.nextInt(90) + 10;
        if (numberB > numberA) {
          int temp = numberA;
          numberA = numberB;
          numberB = temp;
        }
        break;
      case 5:
      // Livello 5: moltiplicazione a due cifre x una cifra
        numberA = randomNumber.nextInt(90) + 10;
        numberB = randomNumber.nextInt(8) + 2; // Evita 0 e 1
        break;
      default:
        currentLevel = 5;
        generateQuestion();
        break;
    }
  }

  // Vai alla prossima domanda
  void goToNextQuestion() {
    // Togli l'alert dialog
    Navigator.of(context).pop();

    setState(() {
      userAnswer = '';
      // Genera una nuova domanda
      generateQuestion();
    });
  }

  // Torna alla domanda corrente
  void goBackToQuestion() {
    // Togli l'alert dialog
    Navigator.of(context).pop();

    setState(() {
      userAnswer = '';
      generateQuestion(); // Genera una nuova domanda per il livello reimpostato
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isDarkModeNotifier,
      builder: (context, isDarkMode, _) {
        // Determina il simbolo dell'operazione
        String operationSymbol;

        switch (currentLevel) {
          case 1:
          case 2:
            operationSymbol = '+';
            break;
          case 3:
          case 4:
            operationSymbol = '-';
            break;
          case 5:
            operationSymbol = '×';
            break;
          default:
            operationSymbol = '+';
            break;
        }

        // Definisci i colori in base alla modalità
        Color backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.blue[400]!;
        Color appBarColor = isDarkMode ? Colors.grey[850]! : Colors.blue[600]!;
        Color textColor = isDarkMode ? Colors.white : Colors.black;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: Text(
              'Math Quiz',
              style: whiteTextStylePiccolo,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings, color: textColor),
                onPressed: () {
                  // Mostra il dialogo delle impostazioni
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SettingsDialog(
                        isDarkMode: isDarkMode,
                        onToggleDarkMode: () {
                          widget.isDarkModeNotifier.value = !widget.isDarkModeNotifier.value;
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              // Contenitore superiore con high score e indicatori di livello
              Container(
                height: 160,
                color: appBarColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Punteggio: $score',
                      style: whiteTextStyle,
                    ),
                    Text(
                      'High Score: $highScore',
                      style: whiteTextStylePiccolo,
                    ),
                    const SizedBox(height: 10),
                    // Indicatori di livello con stelle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < currentLevel ? Icons.star : Icons.star_border,
                          color: Colors.yellow[700],
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // Domanda matematica
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Domanda
                      Text(
                        '$numberA $operationSymbol $numberB = ',
                        style: whiteTextStyle, // Usa whiteTextStyle da const.dart
                      ),
                      // Box risposta utente
                      Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: appBarColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            userAnswer,
                            style: whiteTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tastierino numerico
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GridView.builder(
                    itemCount: numberPad.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemBuilder: (context, index) {
                      return MyButton(
                        child: numberPad[index],
                        onTap: () => buttonTapped(numberPad[index]),
                        isDarkMode: isDarkMode, // Passa isDarkMode al widget
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
