import 'package:hive/hive.dart';
import '../model/diary_entry_model.dart';

class DiaryController {
  static const String _boxName = 'diary_entries';
  late final Box<DiaryEntry> _diaryBox;

  // Make the default constructor private
  DiaryController._();

  // Factory constructor to ensure initialization
  static Future<DiaryController> create() async {
    final instance = DiaryController._();
    await instance._initHive();
    return instance;
  }

  Future<void> _initHive() async {
    _diaryBox = await Hive.openBox<DiaryEntry>(_boxName);
  }

  Future<bool> addEntry(DiaryEntry entry) async {
    // Check if the date already exists
    var existingEntries = _diaryBox.values.where((e) => e.date.isAtSameMomentAs(entry.date)).toList();

    if (existingEntries.length >= 1) {
      return false;
    }

    await _diaryBox.add(entry);  // Using .add() which auto-generates a key.
    return true;
  }

  Future<void> removeEntry(DateTime date) async {
    final keysToDelete = _diaryBox.keys.where((key) {
      final entry = _diaryBox.get(key);
      return entry != null && entry.date.isAtSameMomentAs(date);
    }).toList();

    for (var key in keysToDelete) {
      await _diaryBox.delete(key);
    }
  }

  Future<List<DiaryEntry>> getAllEntries() async {
    return _diaryBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Reverse Chronological order
  }

  Future<DiaryEntry?> getEntry(DateTime date) async {
    try {
      return _diaryBox.values.firstWhere((e) => e.date.isAtSameMomentAs(date));
    } catch (e) {
      return null;
    }
  }


  void dispose() {
    _diaryBox.close();
  }
}
