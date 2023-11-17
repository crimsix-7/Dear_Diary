import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'SignUpView.dart';
import 'ForgotPasswordView.dart'; // Ensure this import is correct for your app structure
import '../main.dart'; // Ensure this import is correct for your app structure

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}
class _SignInViewState extends State<SignInView> {
  static const double _spacing = 8.0; // Consistent spacing
  static const String _signInError = 'An error occurred during sign in';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  String _errorMessage = '';

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DiaryLogWrapper())); // Assuming DiaryLogWrapper is your main app view
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message ?? _signInError);
    }
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) => value != null && value.isEmpty ? 'Please enter your email' : null,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        obscureText: true,
        validator: (value) => value != null && value.length < 6 ? 'Password must be at least 6 characters' : null,
      ),
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        minimumSize: Size(double.infinity, 50.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        textStyle: TextStyle(color: Colors.white, fontSize: 16),
      ),
      onPressed: _signIn,
      child: Text('Sign In'),
    );
  }

  Widget _buildErrorMessage() {
    return _errorMessage.isNotEmpty
        ? Padding(
      padding: EdgeInsets.only(top: _spacing),
      child: Text(_errorMessage, style: TextStyle(color: Colors.redAccent)),
    )
        : SizedBox();
  }

  Widget _buildSignUpRedirect() {
    return TextButton(
      onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SignUpView())),
      child: Text('Don’t have an account? Sign up'),
    );
  }

  Widget _buildForgotPasswordRedirect() {
    return TextButton(
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PasswordResetView())),
      child: Text('Forgot Password?'),
    );
  }

  // This is the added method for the theme toggle switch
  Widget _buildThemeToggleSwitch() {
    var themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return Switch(
      value: themeNotifier.isDarkMode,
      onChanged: (newValue) {
        themeNotifier.toggleTheme();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        actions: [
          _buildThemeToggleSwitch(), // Added theme toggle switch here
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildEmailField(),
              SizedBox(height: _spacing),
              _buildPasswordField(),
              SizedBox(height: _spacing),
              _buildSignInButton(),
              _buildErrorMessage(),
              _buildSignUpRedirect(),
              _buildForgotPasswordRedirect(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
