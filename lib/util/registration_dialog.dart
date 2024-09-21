import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../const.dart';

class RegistrationDialog extends StatefulWidget {
  final bool isDarkMode;

  const RegistrationDialog({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  _RegistrationDialogState createState() => _RegistrationDialogState();
}

class _RegistrationDialogState extends State<RegistrationDialog> {
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isLoading = false;
  String errorMessage = '';

  final _auth = FirebaseAuth.instance;

  void register() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    if (password != confirmPassword) {
      setState(() {
        errorMessage = 'Le password non corrispondono';
        isLoading = false;
      });
      return;
    }

    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Aggiungi l'utente al database con highScore iniziale 0
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'highScore': 0,
      });

      Navigator.of(context).pop(); // Chiudi il dialogo
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Errore durante la registrazione';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.isDarkMode ? Colors.grey[800]! : Colors.blue[800]!;

    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text('Registrati', style: whiteTextStyle),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
              ),
              onChanged: (value) => email = value.trim(),
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
              ),
              onChanged: (value) => password = value.trim(),
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Conferma Password',
                labelStyle: TextStyle(color: Colors.white),
              ),
              onChanged: (value) => confirmPassword = value.trim(),
            ),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
      actions: [
        isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: register,
          child: Text('Registrati'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annulla'),
        ),
      ],
    );
  }
}
