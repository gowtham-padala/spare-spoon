import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/model/recipe_model.dart';

// Class to handle the result of the save recipe dialog result
class SavedRecipeDialogResult {
  final bool isSaved;
  final bool isCancelled;

  SavedRecipeDialogResult({required this.isSaved, required this.isCancelled});
}

/// Class to provide CRUD functionality for recipe
class RecipeService {
  final CollectionReference recipeCollection =
      FirebaseFirestore.instance.collection('recipes');

  /// Add a recipe entry to the fireStore DB
  Future<void> addRecipe(RecipeModel newEntry) async {
    await recipeCollection.add(newEntry.toMap());
  }

  /// Delete a recipe entry by its ID from the fireStore DB
  Future<void> deleteRecipe(String id) async {
    print("Deleting recipe with ID: $id");
    try {
      await recipeCollection.doc(id).delete();
      print("Recipe deleted successfully");
    } catch (e) {
      print("Error deleting recipe: $e");
    }
  }

  /// Update a recipe entry by its ID in the fireStore DB
  Future<void> updateRecipe(String id, RecipeModel updateEntry) async {
    await recipeCollection.doc(id).set(updateEntry.toMap());
  }

  /// Get all favorite recipe for a particular user from the database
  Future<List<RecipeModel>> getAllFavoriteRecipesForAUser(String userId) async {
    var querySnapshot = await recipeCollection.get();
    List<RecipeModel> recipes = [];
    for (var doc in querySnapshot.docs) {
      var entry = RecipeModel.fromMap(doc);
      if (entry.uid == userId && entry.isFavorite) {
        recipes.add(entry);
      }
    }
    return recipes;
  }

  /// Get all the recipes for a user from the database
  Future<List<RecipeModel>> getAllRecipesForAUser(String userId) async {
    var querySnapshot = await recipeCollection.get();
    List<RecipeModel> recipes = [];

    for (var doc in querySnapshot.docs) {
      var entry = RecipeModel.fromMap(doc);
      print(entry.id);
      if (entry.uid == userId) {
        recipes.add(entry);
      }
    }
    return recipes;
  }
}
