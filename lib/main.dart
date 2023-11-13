// lib/main.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'controller/diary_controller.dart';
import 'view/entry_view.dart';
import 'view/viewing_logs.dart';
import 'model/diary_entry_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive initialization
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(DiaryEntryAdapter());

  // clean entries (rerun app)
  //final diaryBox = await Hive.openBox<DiaryEntry>('diary_entries');
  //await diaryBox.clear();
  //await diaryBox.close();
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
      home: DiaryLogWrapper(), // Start with the DiaryLogView
      routes: {
        '/addEntry': (context) => DiaryEntryWrapper(),
      },
    );
  }
}

class DiaryLogWrapper extends StatefulWidget {
  @override
  _DiaryLogWrapperState createState() => _DiaryLogWrapperState();
}

class _DiaryLogWrapperState extends State<DiaryLogWrapper> {
  DiaryController? controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  _initializeController() async {
    controller = await DiaryController.create();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return CircularProgressIndicator(); // Or some loading widget
    }
    return DiaryLogView(controller: controller!);
  }
}

class DiaryEntryWrapper extends StatefulWidget {
  @override
  _DiaryEntryWrapperState createState() => _DiaryEntryWrapperState();
}

class _DiaryEntryWrapperState extends State<DiaryEntryWrapper> {
  DiaryController? controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  _initializeController() async {
    controller = await DiaryController.create();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return CircularProgressIndicator(); // Or some loading widget
    }
    return DiaryEntryView(controller: controller!);
  }
}
