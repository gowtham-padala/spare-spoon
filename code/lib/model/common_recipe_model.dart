import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class for the common recipe.
class CommonRecipeModel {
  String? id; // Unique identifier for the diary entry.
  final String name; // Name of the common recipe
  final String description; // Description of the common recipe
  final String category; // Category of the common recipe
  DateTime creationDate; // Creation of the common recipe
  final String? image; // Image of the common recipe
  double rating;

  CommonRecipeModel({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.creationDate,
    required this.rating,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'rating': rating,
      'creationDate': Timestamp.fromDate(creationDate),
      'image': image,
    };
  }

  factory CommonRecipeModel.fromMap(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>?;

    if (data == null || data.isEmpty) {
      throw Exception("Invalid data or empty document");
    }

    return CommonRecipeModel(
      id: snapshot.id,
      name: data['name'] ?? "",
      description: data['description'] ?? "",
      category: data['category'] ?? "",
      rating: (data['rating'] ?? 0).toDouble(),
      creationDate:
          (data['creationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      image: data['image'] ?? "",
    );
  }
}
