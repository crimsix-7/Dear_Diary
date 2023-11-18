// lib/model/diary_entry_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a diary entry with associated images.
class DiaryEntry {
  final String entryId; // Unique identifier for the diary entry
  final DateTime date; // Date of the diary entry
  final String description; // Description or content of the diary entry
  final int rating; // User-defined rating for the diary entry
  final List<String> imageUrls; // URLs of multiple images associated with the diary entry

  /// Constructs a [DiaryEntry].
  ///
  /// Asserts that the description length is <= 140 characters and rating is between 1 and 5.
  /// The [imageUrls] list can contain multiple URLs, allowing multiple images per diary entry.
  DiaryEntry({
    required this.entryId,
    required this.date,
    required String description,
    required int rating,
    this.imageUrls = const [],
  })  : assert(description.length <= 140, 'Description must be 140 characters or less.'),
        assert(rating >= 1 && rating <= 5, 'Rating must be between 1 and 5.'),
        description = description,
        rating = rating;

  /// Converts a [DiaryEntry] to a map for Firestore storage.
  /// Includes multiple image URLs if available.
  Map<String, dynamic> toMap() {
    return {
      'entryId': entryId,
      'date': Timestamp.fromDate(date),
      'description': description,
      'rating': rating,
      'imageUrls': imageUrls, // Can include multiple URLs
    };
  }

  /// Creates a [DiaryEntry] from a map, typically used when retrieving data from Firestore.
  /// Handles multiple image URLs associated with the diary entry.
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
