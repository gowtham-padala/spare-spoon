import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/model/common_recipe_model.dart';

/// Service class for Common-recipe related operations.
class CommonRecipeService {
  // Initializing the common recipe collection reference
  final CollectionReference commonRecipeCollection =
      FirebaseFirestore.instance.collection('common_recipes');

  // Method to get all the common recipe from the database
  Future<List<CommonRecipeModel>> getCommonRecipes() async {
    var querySnapshot = await commonRecipeCollection.get();
    List<CommonRecipeModel> commonRecipes = [];

    for (var doc in querySnapshot.docs) {
      commonRecipes.add(CommonRecipeModel.fromMap(doc));
    }
    return commonRecipes;
  }

  // Method to update the average rating of the recipe
  Future<void> updateAverageRating(String recipeId, double userRating) async {
    var recipeDoc = commonRecipeCollection.doc(recipeId);
    var recipeSnapshot = await recipeDoc.get();
    if (recipeSnapshot.exists) {
      var recipe = CommonRecipeModel.fromMap(recipeSnapshot);

      double updatedRating = (recipe.rating + userRating) / 2;

      CommonRecipeModel updatedRecipe = CommonRecipeModel(
        name: recipe.name,
        description: recipe.description,
        category: recipe.category,
        creationDate: recipe.creationDate,
        rating: updatedRating,
        isVeg: recipe.isVeg,
        image: recipe.image,
      );

      await recipeDoc.set(updatedRecipe.toMap());
    } else {
      // Handle the case where the recipe document doesn't exist
      print('Recipe with ID $recipeId not found.');
    }
  }
}
