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
  //lista tasti tastierino
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

  //number A, number B
  int numberA = 1;
  int numberB = 1;

  // risposta utente
  String userAnswer = '';

  // utente preme un bottone
  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        //risposta utente data
        checkResult();
      } else if (button == 'C') {
        // pulsante clear
        userAnswer = '';
      } else if (button == 'DEL') {
        //pulsante delete
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      } else if (userAnswer.length < 3) {
        userAnswer += button;
      }
    });
  }

  //check risposta corretta
  void checkResult() {
    if (numberA + numberB == int.parse(userAnswer)) {
      showDialog(
          context: context,
          builder: (context) {
            return ResultMessage(
                message: 'Correct',
                onTap: goToNextQuestion,
                icon: Icons.arrow_forward);
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return ResultMessage(
                message: 'Try Again',
                onTap: goBackToQuestion,
                icon: Icons.rotate_left);
          });
    }
  }

  // crea numeri randomici
  var randomNumber = Random();

  // vai alla prossima domanda
  void goToNextQuestion() {
    //togli alert dialog
    Navigator.of(context).pop();
    // resetta valori
    setState(() {
      userAnswer = '';
    });
    // crea nuova domanda
    numberA = randomNumber.nextInt(10);
    numberB = randomNumber.nextInt(10);
  }

  // torna alla domanda corrente
  void goBackToQuestion() {
    //togli alert dialog
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: Column(
        children: [
          //livello del gioco, il giocatore deve rispondere bene a 5 domande di fila per il prox livello
          Container(
            height: 160,
            color: Colors.blue[600],
          ),

          //domanda matematica
          Expanded(
            child: Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // domanda
                    Text(
                      numberA.toString() + ' + ' + numberB.toString() + ' = ',
                      style: whiteTextStyle,
                    ),
                    // box risposta utente
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

          //tastierino numerico
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
