import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordView extends StatelessWidget {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              child: Text('Reset Password'),
              onPressed: () async {
                await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Password Reset Email Sent'),
                    content: Text('Please check your email to reset your password.'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
