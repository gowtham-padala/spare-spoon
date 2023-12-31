import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  String? id; // Unique identifier for the diary entry.
  String uid; // User ID associated with the diary entry.
  final String name; // Name of the recipe
  final String details; // Details of the recipe
  final String category; // Category of the recipe
  bool isFavorite = false; // If recipe is marked favorite or not
  DateTime creationDate; // Creation Date of the diary entry.
  DateTime updateDate; // Update Date of the diary entry.
  List<String>? images; // Images of the recipe

  RecipeModel({
    this.id,
    required this.uid,
    required this.name,
    required this.details,
    required this.category,
    required this.isFavorite,
    required this.creationDate,
    required this.updateDate,
    this.images,
  });

  // Factory method to create a DiaryModel object from a Map<String, dynamic> object.
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      'name': name,
      'details': details,
      "category": category,
      'isFavorite': isFavorite,
      'creationDate': Timestamp.fromDate(creationDate),
      'updateDate': Timestamp.fromDate(updateDate),
      'images': images,
    };
  }

  // Factory method to create a DiaryModel object from a Map<String, dynamic> object.
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
      category: data['category'] ?? "",
      isFavorite: (data['isFavorite'] ?? false),
      creationDate:
          (data['creationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updateDate:
          (data['updateDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      images: data['images']?.cast<String>(), // Assuming images are URLs.
    );
  }
}
