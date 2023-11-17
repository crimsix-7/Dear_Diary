import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'controller/diary_controller.dart';
import 'view/add_edit_diary_entry_view.dart';
import 'view/diary_list_view.dart';
import 'view/LoginView.dart';
import 'view/ForgotPasswordView.dart';
import 'view/SignUpView.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: DiaryApp(),
    ),
  );
}

class ThemeNotifier with ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();

  // Added the isDarkMode getter
  bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentTheme = isDarkMode ? ThemeData.light() : ThemeData.dark();
    notifyListeners();
  }
}

class DiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Dear Diary',
          theme: themeNotifier.currentTheme,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return DiaryLogWrapper();
              } else {
                return SignInView();
              }
            },
          ),
          routes: {
            '/addEntry': (context) => DiaryEntryWrapper(),
            '/forgotPassword': (context) => PasswordResetView(),
            '/signUp': (context) => SignUpView(),
            // Add other routes as necessary
          },
        );
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
  }

  @override
  Widget build(BuildContext context) {
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
  }

  @override
  Widget build(BuildContext context) {
    return AddEditDiaryEntryView(controller: controller);
  }
}
