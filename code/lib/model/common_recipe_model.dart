import 'package:cloud_firestore/cloud_firestore.dart';

class CommonRecipeModel {
  final String name; // Name of the common recipe
  final String description; // Description of the common recipe

  CommonRecipeModel({
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
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
    );
  }
}
