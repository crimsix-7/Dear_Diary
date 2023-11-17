// lib/model/diary_entry_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a diary entry.
class DiaryEntry {
  final String entryId;
  final DateTime date;
  final String description;
  final int rating;
  final List<String> imageUrls;

  /// Constructs a [DiaryEntry] with the given values, ensuring that [description]
  /// does not exceed 140 characters and [rating] is between 1 and 5.
  DiaryEntry({
    required this.entryId,
    required this.date,
    required String description,
    required int rating,
    this.imageUrls = const [],
  })  : assert(description.length <= 140, 'Description cannot exceed 140 characters.'),
        assert(rating >= 1 && rating <= 5, 'Rating must be between 1 and 5 stars.'),
        description = description,
        rating = rating;

  /// Converts a [DiaryEntry] to a map for serialization.
  Map<String, dynamic> toMap() {
    return {
      'entryId': entryId,
      'date': Timestamp.fromDate(date),
      'description': description,
      'rating': rating,
      'imageUrls': imageUrls,
    };
  }

  /// Creates a [DiaryEntry] from a map after deserialization.
  static DiaryEntry fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      entryId: map['entryId'] as String,
      date: (map['date'] as Timestamp).toDate(),
      description: map['description'] as String,
      rating: map['rating'] as int,
      imageUrls: List<String>.from(map['imageUrls'] as List<dynamic>),
    );
  }
}
