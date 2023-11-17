import 'package:firebase_auth/firebase_auth.dart';

/// Manages user authentication operations with Firebase.
class AuthenticationManager {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Registers a new user with their email and password.
  /// Returns a custom result object containing user data or an error message.
  Future<AuthResult> registerUser(String email, String password) async {
    try {
      final UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(user: credential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e.message);
    }
  }

  /// Signs in the user using their email and password.
  /// Returns a custom result object containing user data or an error message.
  Future<AuthResult> loginUser(String email, String password) async {
    try {
      final UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(user: credential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e.message);
    }
  }

  /// Sends a password reset email to the given email.
  Future<void> sendPasswordReset(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Stream of user authentication state changes.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}

/// Represents the result of an authentication operation.
class AuthResult {
  final User? user;
  final String? error;

  AuthResult({this.user, this.error});
}
