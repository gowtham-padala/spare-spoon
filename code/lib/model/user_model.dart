// Importing necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';

// Model class representing user data
class UserModel {
  final String id; // Unique identifier for the user
  final String name; // User's name
  final String email; // User's email address
  final String sex; // User's gender
  final int age; // User's age
  final List<String> dietaryPreferences; // List of dietary preferences
  final List<String> intolerances; // List of intolerances
  final List<String> allergies; // List of allergies

  // Constructor to initialize UserModel with required attributes
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.sex,
    required this.age,
    required this.dietaryPreferences,
    required this.intolerances,
    required this.allergies,
  });

  // Convert UserModel to a map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'sex': sex,
      'age': age,
      'dietaryPreferences': dietaryPreferences,
      'intolerances': intolerances,
      'allergies': allergies,
    };
  }

  // Factory method to create a UserModel instance from a Firestore document snapshot
  factory UserModel.fromMap(DocumentSnapshot doc) {
    // Extracting data from the document snapshot
    final data = doc.data() as Map<String, dynamic>;
    // Creating a new UserModel instance using the extracted data
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '', // Using default values if data is null
      email: data['email'] ?? '',
      sex: data['sex'] ?? '',
      age: data['age'] ?? 0,
      // Converting lists from dynamic to String
      dietaryPreferences: (data['dietaryPreferences'] as List<dynamic>)
          .map((pref) => pref.toString())
          .toList(),
      intolerances: (data['intolerances'] as List<dynamic>)
          .map((intolerance) => intolerance.toString())
          .toList(),
      allergies: (data['allergies'] as List<dynamic>)
          .map((allergy) => allergy.toString())
          .toList(),
    );
  }

}
