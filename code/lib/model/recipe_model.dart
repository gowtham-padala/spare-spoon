import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  String? id; // Unique identifier for the diary entry.
  String uid; // User ID associated with the diary entry.
  final String name; // Name of the recipe
  final String details; // Details of the recipe
  bool isFavorite = false; // If recipe is marked favorite or not
  DateTime date; // Date of the diary entry.
  List<String>? images; // Use a more specific type if possible.

  RecipeModel({
    this.id,
    required this.uid,
    required this.name,
    required this.details,
    required this.isFavorite,
    required this.date,
    this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      'name': name,
      'details': details,
      'isFavorite': isFavorite,
      'date': Timestamp.fromDate(date),
      'images': images,
    };
  }

  factory RecipeModel.fromMap(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>?;

    if (data == null || data.isEmpty) {
      throw Exception("Invalid data or empty document");
    }

    return RecipeModel(
      id: snapshot.id,
      uid: data['uid'] ?? "",
      name: data['name'] ?? "",
      details: data['details'] ?? "",
      isFavorite: (data['isFavorite'] ?? 0).toDouble(),
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      images: data['images']?.cast<String>(), // Assuming images are URLs.
    );
  }
}
