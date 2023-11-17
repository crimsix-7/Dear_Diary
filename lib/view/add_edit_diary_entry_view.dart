import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for DateFormat
import '../model/diary_entry_model.dart';
import '../controller/diary_controller.dart';

class AddEditDiaryEntryView extends StatefulWidget {
  final DiaryController controller;
  final DiaryEntry? existingEntry; // null if adding a new entry

  AddEditDiaryEntryView({required this.controller, this.existingEntry});

  @override
  _AddEditDiaryEntryViewState createState() => _AddEditDiaryEntryViewState();
}

class _AddEditDiaryEntryViewState extends State<AddEditDiaryEntryView> {
  late TextEditingController _descriptionController;
  late int _rating;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.existingEntry?.description ?? '');
    _rating = widget.existingEntry?.rating ?? 3; // Default rating
    _selectedDate = widget.existingEntry?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveEntry() {
    if (_descriptionController.text.length <= 140) {
      DiaryEntry entry = DiaryEntry(
        entryId: widget.existingEntry?.entryId ?? '', // Use existing ID if editing, else empty (will be assigned in Firestore)
        date: _selectedDate,
        description: _descriptionController.text,
        rating: _rating,
      );
      if (widget.existingEntry == null) {
        widget.controller.addDiaryEntry(entry);
      } else {
        widget.controller.updateDiaryEntry(widget.existingEntry!.entryId, entry);
      }
      Navigator.pop(context, true); // Return to previous screen after save
    } else {
      _showSnackbar('Description cannot exceed 140 characters');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existingEntry == null ? 'Add Diary Entry' : 'Edit Diary Entry')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  initialValue: DateFormat('yyyy-MM-dd').format(_selectedDate),
                  decoration: InputDecoration(labelText: 'Date'),
                ),
              ),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLength: 140,
            ),
            DropdownButton<int>(
              value: _rating,
              onChanged: (int? newValue) {
                setState(() {
                  _rating = newValue!;
                });
              },
              items: <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value Stars'),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _saveEntry,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
