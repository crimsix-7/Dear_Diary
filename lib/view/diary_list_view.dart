import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/diary_entry_model.dart';
import '../controller/diary_controller.dart';
import 'add_edit_diary_entry_view.dart'; // Correct import for AddEditDiaryEntryView
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginView.dart'; // Make sure this import path is correct

class DiaryLogView extends StatefulWidget {
  final DiaryController controller;

  DiaryLogView({required this.controller});

  @override
  _DiaryLogViewState createState() => _DiaryLogViewState();
}

class _DiaryLogViewState extends State<DiaryLogView> {
  Future<List<DiaryEntry>>? entriesFuture;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    _fetchEntries();
  }

  void _fetchEntries() {
    if (userId != null) {
      entriesFuture = widget.controller.getDiaryEntries();
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SignInView()));
  }

  Widget _buildDiaryEntryList(List<DiaryEntry> entries) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) => _buildDiaryEntryItem(entries[index]),
    );
  }

  Widget _buildDiaryEntryItem(DiaryEntry entry) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(entry.description),
        subtitle: Text(DateFormat('yyyy-MM-dd').format(entry.date)),
        trailing: _buildEntryActions(entry),
        onLongPress: () => _editEntry(entry),
      ),
    );
  }

  Widget _buildEntryActions(DiaryEntry entry) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(entry.rating, (index) => const Icon(Icons.star, color: Colors.yellow, size: 20.0)),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.grey),
          onPressed: () => _deleteEntry(entry),
        ),
      ],
    );
  }

  Future<void> _editEntry(DiaryEntry entry) async {
    final edited = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => AddEditDiaryEntryView(controller: widget.controller, existingEntry: entry)),
    );
    if (edited != null && edited == true) {
      setState(_fetchEntries);
    }
  }

  Future<void> _deleteEntry(DiaryEntry entry) async {
    await widget.controller.deleteDiaryEntry(entry.entryId);
    setState(_fetchEntries);
  }

  Widget _buildFloatingActionButtons() {
    return FloatingActionButton(
      heroTag: 'addButton',
      onPressed: _addNewEntry,
      child: const Icon(Icons.add),
      tooltip: 'Add Entry',
    );
  }

  Future<void> _addNewEntry() async {
    final added = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => AddEditDiaryEntryView(controller: widget.controller)),
    );
    if (added != null && added == true) {
      setState(_fetchEntries);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Log'),
        actions: <Widget>[IconButton(icon: const Icon(Icons.exit_to_app), onPressed: _logout, tooltip: 'Logout')],
      ),
      body: FutureBuilder<List<DiaryEntry>>(
        future: entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData | snapshot.data!.isEmpty) {
            return const Center(child: Text('No entries found.', style: TextStyle(fontSize: 20.0)));
          } else {
            return _buildDiaryEntryList(snapshot.data!);
          }
        },
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }
}
