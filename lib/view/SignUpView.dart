import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpView extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              child: Text('Sign Up'),
              onPressed: () async {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
                Navigator.pushReplacementNamed(context, '/home'); // Navigate to home on success
              },
            ),
          ],
        ),
      ),
    );
  }
}
