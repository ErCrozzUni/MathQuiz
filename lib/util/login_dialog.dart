import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../const.dart';
import 'registration_dialog.dart';

class LoginDialog extends StatefulWidget {
  final bool isDarkMode;

  const LoginDialog({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  String email = '';
  String password = '';
  bool isLoading = false;
  String errorMessage = '';

  final _auth = FirebaseAuth.instance;

  void login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        isLoading = false;
        errorMessage = ''; // Resetta il messaggio di errore dopo il login riuscito
      });
      Navigator.of(context).pop(); // Chiudi il dialogo dopo il login
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = 'Email o password errati';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = '';
        isLoading = false;
      });
    }
  }

  void openRegistrationDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return RegistrationDialog(isDarkMode: widget.isDarkMode);
      },
    );

    // Dopo la registrazione, se l'utente è loggato, chiudi il LoginDialog
    if (_auth.currentUser != null) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
    widget.isDarkMode ? Colors.grey[800]! : Colors.blue[800]!;

    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text('Login', style: whiteTextStyle),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
              ),
              onChanged: (value) => email = value.trim(),
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
              ),
              onChanged: (value) => password = value.trim(),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: isLoading ? null : login,
          child: const Text('Login'),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : openRegistrationDialog,
          child: const Text('Registrati'),
        ),
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
            Navigator.of(context).pop();
          },
          child: const Text('Annulla'),
        ),
      ],
    );
  }
}
