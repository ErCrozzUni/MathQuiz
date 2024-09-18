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

  // Numero A, Numero B
  int numberA = 1;
  int numberB = 1;

  // Risposta utente
  String userAnswer = '';

  // Contatore di risposte corrette consecutive
  int correctStreak = 0;

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
    if (numberA + numberB == int.parse(userAnswer)) {
      setState(() {
        correctStreak += 1;
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

  // Crea numeri randomici
  var randomNumber = Random();

  // Vai alla prossima domanda
  void goToNextQuestion() {
    // Togli alert dialog
    Navigator.of(context).pop();
    // Resetta valori
    setState(() {
      userAnswer = '';
      // Crea nuova domanda
      numberA = randomNumber.nextInt(10);
      numberB = randomNumber.nextInt(10);
    });
  }

  // Torna alla domanda corrente
  void goBackToQuestion() {
    // Togli alert dialog
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: Column(
        children: [
          // Livello del gioco, il giocatore deve rispondere bene a 5 domande di fila per il prossimo livello
          Container(
            height: 160,
            color: Colors.blue[600],
            child: Center(
              child: Text(
                'Livelli superati: $correctStreak',
                style: whiteTextStyle,
              ),
            ),
          ),

          // Domanda matematica
          Expanded(
            child: Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Domanda
                    Text(
                      '$numberA + $numberB = ',
                      style: whiteTextStyle,
                    ),
                    // Box risposta utente
                    Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
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
