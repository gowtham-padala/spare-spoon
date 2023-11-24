import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/model/recipe_model.dart';

class RecipeDialogResult {
  final String recipeName;
  final bool isFavorite;
  final bool isCancelled;

  RecipeDialogResult(this.recipeName, this.isFavorite, this.isCancelled);
}

class RecipeService {
  final CollectionReference recipeCollection =
      FirebaseFirestore.instance.collection('recipes');

  Future<void> addRecipe(RecipeModel newEntry) async {
    await recipeCollection.add(newEntry.toMap());
  }

  /// Delete a recipe entry by its ID.
  Future<void> deleteDiary(String id) async {
    await recipeCollection.doc(id).delete();
  }

  /// Update a recipe entry by its ID.
  Future<void> updateDiary(String id, RecipeModel updateEntry) async {
    await recipeCollection.doc(id).set(updateEntry.toMap());
  }

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

  Future<List<RecipeModel>> getAllRecipesForAUser(String userId) async {
    var querySnapshot = await recipeCollection.get();
    List<RecipeModel> recipes = [];

    for (var doc in querySnapshot.docs) {
      var entry = RecipeModel.fromMap(doc);
      if (entry.uid == userId) {
        recipes.add(entry);
      }
    }
    return recipes;
  }
}
