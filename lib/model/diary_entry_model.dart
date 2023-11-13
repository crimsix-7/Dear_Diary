// lib/model/diary_entry_model.dart
import 'package:hive/hive.dart';
part 'diary_entry_model.g.dart';


@HiveType(typeId: 0)
class DiaryEntry {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final int rating; // 1 to 5 stars

  DiaryEntry(
      {required this.date, required this.description, required this.rating});
}
