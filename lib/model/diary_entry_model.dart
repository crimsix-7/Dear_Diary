// lib/model/diary_entry_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryEntry {
  final String entryId;
  final DateTime date;
  final String description;
  final int rating;
  final List<String> imageUrls;

  DiaryEntry({
    required this.entryId,
    required this.date,
    required String description,
    required int rating,
    this.imageUrls = const [],
  })  : assert(description.length <= 140),
        assert(rating >= 1 && rating <= 5),
        description = description,
        rating = rating;

  Map<String, dynamic> toMap() {
    return {
      'entryId': entryId,
      'date': Timestamp.fromDate(date),
      'description': description,
      'rating': rating,
      'imageUrls': imageUrls,
    };
  }

  static DiaryEntry fromMap(Map<String, dynamic> map, String docId) {
    return DiaryEntry(
      entryId: docId,
      date: (map['date'] as Timestamp).toDate(),
      description: map['description'] as String,
      rating: map['rating'] as int,
      imageUrls: List<String>.from(map['imageUrls'] as List<dynamic>),
    );
  }
}
