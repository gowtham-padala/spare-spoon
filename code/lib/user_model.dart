import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String sex;
  final int age;
  final List<String> dietaryPreferences;
  final List<String> intolerances;
  final List<String> allergies;

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

  factory UserModel.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      sex: data['sex'] ?? '',
      age: data['age'] ?? 0,
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
