// lib/main.dart

// Main
import 'package:flutter/material.dart';

// Controllers
import 'controller/diary_controller.dart';

// Views
import 'view/add_edit_diary_entry_view.dart';
import 'view/diary_list_view.dart';
import 'view/LoginView.dart';
import 'view/ForgotPasswordView.dart'; // Make sure this import path is correct
import 'view/SignUpView.dart'; // Make sure this import path is correct

// FireBase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // This should point to your generated Firebase options file
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Uncomment the following line if you want to sign out the user every time the app starts
  // await FirebaseAuth.instance.signOut();

  runApp(DiaryApp());
}

class DiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dear Diary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return DiaryLogWrapper(); // User is signed in
          } else {
            return SignInView(); // User is not signed in, show SignInView
          }
        },
      ),
      routes: {
        '/addEntry': (context) => DiaryEntryWrapper(),
        '/forgotPassword': (context) => PasswordResetView(), // Added route for ForgotPasswordView
        '/signUp': (context) => SignUpView(), // Added route for SignUpView
        // Add other routes as necessary
      },
    );
  }
}

class DiaryLogWrapper extends StatefulWidget {
  @override
  _DiaryLogWrapperState createState() => _DiaryLogWrapperState();
}

class _DiaryLogWrapperState extends State<DiaryLogWrapper> {
  DiaryController controller = DiaryController();

  @override
  void initState() {
    super.initState();
    // Firebase Firestore initialization or other setup if necessary
  }

  @override
  Widget build(BuildContext context) {
    // Firebase Firestore related UI code if necessary
    return DiaryLogView(controller: controller);
  }
}

class DiaryEntryWrapper extends StatefulWidget {
  @override
  _DiaryEntryWrapperState createState() => _DiaryEntryWrapperState();
}

class _DiaryEntryWrapperState extends State<DiaryEntryWrapper> {
  DiaryController controller = DiaryController();

  @override
  void initState() {
    super.initState();
    // Firebase Firestore initialization or other setup if necessary
  }

  @override
  Widget build(BuildContext context) {
    // Firebase Firestore related UI code if necessary
    return AddEditDiaryEntryView(controller: controller);
  }
}
