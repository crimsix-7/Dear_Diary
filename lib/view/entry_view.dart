// lib/view/diary_entry_view.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/diary_entry_model.dart';
import '../controller/diary_controller.dart';

class DiaryEntryView extends StatefulWidget {
  final DiaryController controller;

  DiaryEntryView({required this.controller});

  @override
  _DiaryEntryViewState createState() => _DiaryEntryViewState();
}

class _DiaryEntryViewState extends State<DiaryEntryView> {
  late DateTime selectedDate;
  String description = '';
  int rating = 1;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _clearTodayEntries() async {
    final todayEntries = Hive.box<DiaryEntry>('diary_entries').values.where((entry) {
      return entry.date.isAtSameMomentAs(DateTime.now());
    }).toList();

    for (var entry in todayEntries) {
      await Hive.box<DiaryEntry>('diary_entries').delete(entry.date.toIso8601String());
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('All entries for today have been deleted!')));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        colorScheme: ThemeData.dark().colorScheme.copyWith(secondary: Colors.blueAccent),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('Add Diary Entry')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select date: ${selectedDate.toLocal()}'.split(' ')[0]),
              ),
              TextField(
                maxLength: 140,
                onChanged: (value) => description = value,
                decoration: const InputDecoration(
                    hintText: 'Enter your diary note (Max: 140 characters)'),
              ),
              Slider(
                value: rating.toDouble(),
                onChanged: (newRating) {
                  setState(() => rating = newRating.toInt());
                },
                divisions: 4,
                label: rating.toString(),
                min: 1,
                max: 5,
              ),
              ElevatedButton(
                onPressed: () async {
                  final entry = DiaryEntry(
                      date: selectedDate,
                      description: description,
                      rating: rating);
                  bool wasAdded = await widget.controller.addEntry(entry);
                  if (!wasAdded) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Entry for this date already exists!')));
                  } else {
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Save Entry'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.delete_forever),
          onPressed: _clearTodayEntries,
        ),
      ),
    );
  }
}
