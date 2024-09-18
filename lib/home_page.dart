import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_croz_benz/util/my_button.dart';
import 'package:math_croz_benz/util/result_message.dart';
import 'const.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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

  // Contatore di risposte corrette consecutive
  int correctStreak = 0;

  // High score
  int highScore = 0;

  // Livello corrente (inizia da 1)
  int currentLevel = 1; // Livelli da 1 a 5

  // Modalità scura
  bool isDarkMode = false;

  // Generatore di numeri casuali
  var randomNumber = Random();

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

  // Check risposta corretta
  void checkResult() {
    int correctAnswer;

    // Calcola la risposta corretta in base al livello
    switch (currentLevel) {
      case 1:
      case 2:
        correctAnswer = numberA + numberB;
        break;
      case 3:
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
      setState(() {
        correctStreak += 1;
        if (correctStreak > highScore) {
          highScore = correctStreak;
        }
      });
      showDialog(
        context: context,
        builder: (context) {
          return ResultMessage(
            message: 'Corretto',
            onTap: goToNextQuestion,
            icon: Icons.arrow_forward,
          );
        },
      );
    } else {
      setState(() {
        correctStreak = 0;
      });
      showDialog(
        context: context,
        builder: (context) {
          return ResultMessage(
            message: 'Riprova',
            onTap: goBackToQuestion,
            icon: Icons.rotate_left,
          );
        },
      );
    }
  }

  // Genera una nuova domanda in base al livello
  void generateQuestion() {
    switch (currentLevel) {
      case 1:
      // Livello 1: addizione a una cifra
        numberA = randomNumber.nextInt(10);
        numberB = randomNumber.nextInt(10);
        break;
      case 2:
      // Livello 2: addizione a due cifre
        numberA = randomNumber.nextInt(90) + 10;
        numberB = randomNumber.nextInt(90) + 10;
        break;
      case 3:
      // Livello 3: sottrazione a una cifra
        numberA = randomNumber.nextInt(10);
        numberB = randomNumber.nextInt(10);
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
        numberB = randomNumber.nextInt(9) + 1; // Evita lo zero
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

      // Incrementa il livello ogni 10 risposte corrette
      if (correctStreak % 10 == 0 && correctStreak != 0 && currentLevel < 5) {
        currentLevel += 1;
      }

      // Genera una nuova domanda
      generateQuestion();
    });
  }

  // Torna alla domanda corrente
  void goBackToQuestion() {
    // Togli l'alert dialog
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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

    // Colori in base alla modalità
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
              // Mostra il menu per cambiare modalità
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width,
                  kToolbarHeight,
                  0,
                  0,
                ),
                items: [
                  const PopupMenuItem(
                    value: 'toggle_dark_mode',
                    child: Text('Cambia modalità'),
                  ),
                ],
              ).then((value) {
                if (value == 'toggle_dark_mode') {
                  setState(() {
                    isDarkMode = !isDarkMode;
                  });
                }
              });
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
                  'Risposte corrette: $correctStreak',
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
                      index < currentLevel - 1 ? Icons.star : Icons.star_border,
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
                    style: whiteTextStyle,
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
                  )
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
