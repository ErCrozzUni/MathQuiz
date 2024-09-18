import 'package:flutter/material.dart';

import '../const.dart';

class ResultMessage extends StatelessWidget {
  final VoidCallback onTap;
  final icon;
  final String message;

  const ResultMessage({
    Key? key,
    required this.message,
    required this.onTap,
    required this.icon,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue[800],
      content: Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //risultato
            Text(
              message,
              style: whiteTextStyle,
            ),
            //bottone prossima domanda
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.blue[400],
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Icon(
                    icon,
                    color: Colors.white
                ),
              ),
            )
          ],
        ),
      ),
    );;
  }
}
