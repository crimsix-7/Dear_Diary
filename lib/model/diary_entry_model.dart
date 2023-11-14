class DiaryEntry {
  String id; // Firestore document ID
  DateTime date;
  String description;
  int rating;

  DiaryEntry({required this.id, required this.date, required this.description, required this.rating});

  Map<String, dynamic> toMap() {
    return {
      // Do not include 'id' here, as it's not part of the document data
      'date': date.toIso8601String(),
      'description': description,
      'rating': rating,
    };
  }

  static DiaryEntry fromMap(String id, Map<String, dynamic> map) {
    return DiaryEntry(
      id: id,
      date: DateTime.parse(map['date']),
      description: map['description'],
      rating: map['rating'],
    );
  }
}
