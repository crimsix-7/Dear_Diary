import 'package:flutter/material.dart';
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

  Widget _buildEmailField() => TextFormField(
        controller: _emailController,
        decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
        keyboardType: TextInputType.emailAddress,
        validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
      );

  Widget _buildPasswordField() => TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
        obscureText: true,
        validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
      );

  Widget _buildSignInButton() => ElevatedButton(onPressed: _signIn, child: Text('Sign In'));

  Widget _buildErrorMessage() => _errorMessage.isNotEmpty
      ? Padding(
          padding: EdgeInsets.only(top: _spacing),
          child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
        )
      : SizedBox();

  Widget _buildSignUpRedirect() => TextButton(
        onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SignUpView())),
        child: Text('Don’t have an account? Sign up'),
      );

  Widget _buildForgotPasswordRedirect() => TextButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PasswordResetView())),
        child: Text('Forgot Password?'),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Sign In')),
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
                _buildForgotPasswordRedirect(), // Added this line for the forgot password redirect
              ],
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
