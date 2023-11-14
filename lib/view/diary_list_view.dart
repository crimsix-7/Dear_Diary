import 'package:flutter/material.dart';
import '../model/diary_entry_model.dart';
import '../controller/diary_controller.dart';
import 'add_edit_diary_entry_view.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class DiaryLogView extends StatefulWidget {
  final DiaryController controller;

  DiaryLogView({required this.controller});

  @override
  _DiaryLogViewState createState() => _DiaryLogViewState();
}

class _DiaryLogViewState extends State<DiaryLogView> {
  Future<List<DiaryEntry>>? entriesFuture;

  @override
  void initState() {
    super.initState();
    _fetchEntries();
  }

  void _fetchEntries() {
    entriesFuture = widget.controller.getDiaryEntries();
  }

  void _deleteEntry(String docId) async {
    await widget.controller.deleteDiaryEntry(docId);
    setState(_fetchEntries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diary Log')),
      body: FutureBuilder<List<DiaryEntry>>(
        future: entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No entries found.', style: TextStyle(fontSize: 20.0)));
          } else {
            final entries = snapshot.data!;
            final groupedEntries = groupBy(entries, (DiaryEntry e) {
              return DateFormat('MMMM yyyy').format(e.date);
            });

            return ListView.builder(
              itemCount: groupedEntries.keys.length,
              itemBuilder: (context, groupIndex) {
                final monthYear = groupedEntries.keys.elementAt(groupIndex);
                final monthEntries = groupedEntries[monthYear]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(monthYear, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    ...monthEntries.map((entry) => _buildDiaryEntryItem(entry)).toList(),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditView(context),
        child: const Icon(Icons.add),
        tooltip: 'Add Entry',
      ),
    );
  }

  Widget _buildDiaryEntryItem(DiaryEntry entry) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        title: Text(entry.description),
        subtitle: Text(DateFormat('yyyy-MM-dd').format(entry.date)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(entry.rating, (index) => const Icon(Icons.star, color: Colors.yellow, size: 20.0)),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () => _deleteEntry(entry.id),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddEditView(BuildContext context) async {
    final added = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditDiaryEntryView(controller: widget.controller)),
    );
    if (added != null && added) {
      setState(_fetchEntries);
    }
  }
}
