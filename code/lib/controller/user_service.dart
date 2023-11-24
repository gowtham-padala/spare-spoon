// Importing necessary packages and local model
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

// Controller class for handling user-related operations in Firestore
class UserService {
  final String userId; // User ID for whom the operations are performed
  final CollectionReference userCollection; // Firestore collection reference

  // Constructor to initialize the UserController with a user ID
  UserService(this.userId)
      : userCollection = FirebaseFirestore.instance.collection('users');

  // Create a new user document in Firestore
  Future<void> createUser(UserModel userModel) async {
    await userCollection.doc(userId).set(userModel.toMap());
  }

  // Retrieve user data from Firestore based on the user ID
  Future<UserModel?> getUserData() async {
    // Get the document snapshot for the specified user ID
    final doc = await userCollection.doc(userId).get();
    if (doc.exists) {
      // If the document exists, convert it to a UserModel instance and return
      return UserModel.fromMap(doc);
    } else {
      // If the document doesn't exist, return null
      return null;
    }
  }

  // Update user data in Firestore with new UserModel information
  Future<void> updateUserData(UserModel userModel) async {
    await userCollection.doc(userId).update(userModel.toMap());
  }

  // Delete user data from Firestore based on the user ID
  Future<void> deleteUserData() async {
    await userCollection.doc(userId).delete();
  }
}
