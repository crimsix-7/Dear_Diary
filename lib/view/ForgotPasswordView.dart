import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginView.dart'; // Import your sign-in view

class PasswordResetView extends StatefulWidget {
  @override
  _PasswordResetViewState createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends State<PasswordResetView> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  String _successMessage = '';
  String _errorMessage = '';

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      setState(() {
        _successMessage = 'Password reset email sent. Check your email.';
        _errorMessage = '';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An error occurred';
        _successMessage = '';
      });
    }
  }

  Widget _buildEmailField() => TextFormField(
        controller: _emailController,
        decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
        keyboardType: TextInputType.emailAddress,
        validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
      );

  Widget _buildResetPasswordButton() => ElevatedButton(onPressed: _resetPassword, child: Text('Reset Password'));

  Widget _buildSuccessMessage() => _successMessage.isNotEmpty
      ? Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(_successMessage, style: TextStyle(color: Colors.green)),
        )
      : SizedBox();

  Widget _buildErrorMessage() => _errorMessage.isNotEmpty
      ? Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
        )
      : SizedBox();

  Widget _buildSignInRedirect() => TextButton(
        onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SignInView())),
        child: Text('Remembered your password? Sign in'),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Reset Password')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildEmailField(),
                SizedBox(height: 8),
                _buildResetPasswordButton(),
                _buildSuccessMessage(),
                _buildErrorMessage(),
                _buildSignInRedirect(),
              ],
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
