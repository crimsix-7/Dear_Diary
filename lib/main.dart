// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'controller/diary_controller.dart';
import 'view/LoginView.dart';
import 'view/SignUpView.dart';
import 'view/ForgotPasswordView.dart';
import 'view/diary_list_view.dart';
import 'view/add_edit_diary_entry_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      initialRoute: '/',
      routes: {
        '/': (context) => AuthenticationWrapper(),
        '/signUp': (context) => SignUpView(),
        '/forgotPassword': (context) => ForgotPasswordView(),
        '/diary': (context) => DiaryLogWrapper(),
        '/addEntry': (context) => DiaryEntryWrapper(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return DiaryLogWrapper();
        } else {
          return LoginView();
        }
      },
    );
  }
}

class DiaryLogWrapper extends StatefulWidget {
  @override
  _DiaryLogWrapperState createState() => _DiaryLogWrapperState();
}

class _DiaryLogWrapperState extends State<DiaryLogWrapper> {
  late DiaryController controller;

  @override
  void initState() {
    super.initState();
    controller = DiaryController();
  }

  @override
  Widget build(BuildContext context) {
    return DiaryLogView(controller: controller);
  }
}

class DiaryEntryWrapper extends StatelessWidget {
  final DiaryController controller = DiaryController();

  @override
  Widget build(BuildContext context) {
    return AddEditDiaryEntryView(controller: controller);
  }
}
