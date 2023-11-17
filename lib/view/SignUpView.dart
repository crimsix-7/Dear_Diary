import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginView.dart'; // Import your sign-in view

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  static const double _spacing = 8.0; // Added constant for spacing
  static const String _signUpError = 'An error occurred during sign up';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  String _errorMessage = '';

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SignInView()));
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message ?? _signUpError);
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

  Widget _buildSignUpButton() => ElevatedButton(onPressed: _signUp, child: Text('Sign Up'));

  Widget _buildErrorMessage() => _errorMessage.isNotEmpty
      ? Padding(
          padding: EdgeInsets.only(top: _spacing),
          child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
        )
      : SizedBox();

  Widget _buildSignInRedirect() => TextButton(
        onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SignInView())),
        child: Text('Already have an account? Sign in'),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Sign Up')),
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
                _buildSignUpButton(),
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
    _passwordController.dispose();
    super.dispose();
  }
}
