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
      Navigator.of(context).pop(); // Chiudi il dialogo
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = 'Username o password errati';
        isLoading = false;
      });
    }
  }

  void openRegistrationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return RegistrationDialog(isDarkMode: widget.isDarkMode);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.isDarkMode ? Colors.grey[800]! : Colors.blue[800]!;

    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text('Login', style: whiteTextStyle),
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
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: openRegistrationDialog,
          child: Text('Registrati'),
        ),
        isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: login,
          child: Text('Login'),
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
