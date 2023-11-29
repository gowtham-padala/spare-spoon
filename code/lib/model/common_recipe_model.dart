import 'package:cloud_firestore/cloud_firestore.dart';

class CommonRecipeModel {
  final String name; // Name of the common recipe
  final String description; // Description of the common recipe
  final String category; // Description of the common recipe
  DateTime creationDate; // Description of the common recipe
  final String? image;

  CommonRecipeModel({
    required this.name,
    required this.description,
    required this.category,
    required this.creationDate,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
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
      name: data['name'] ?? "",
      description: data['description'] ?? "",
      category: data['category'] ?? "",
      creationDate:
          (data['creationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      image: data['image'] ?? "",
    );
  }
}
