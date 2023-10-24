import './user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  final String userId;
  final CollectionReference userCollection;

  UserController(this.userId)
      : userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel userModel) async {
    await userCollection.doc(userId).set(userModel.toMap());
  }

  Future<UserModel?> getUserData() async {
    final doc = await userCollection.doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc);
    } else {
      return null;
    }
  }

  Future<void> updateUserData(UserModel userModel) async {
    await userCollection.doc(userId).update(userModel.toMap());
  }

  Future<void> deleteUserData() async {
    await userCollection.doc(userId).delete();
  }
}
