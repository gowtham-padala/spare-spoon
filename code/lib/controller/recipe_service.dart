import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/model/recipe_model.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> saveRecipe(String userName, RecipeModel recipe) async {
  try {
    // Check if a collection for the user already exists
    final userCollection = _firestore.collection('users').doc(userName);
    final userCollectionExists = await userCollection.get().then((doc) => doc.exists);

    if (!userCollectionExists) {
      // If the user collection doesn't exist, create it
      await userCollection.set({});
    }

    // Save the recipe to the user-specific collection
    await userCollection.collection('recipes').add({
      'name': recipe.name,
      'recipe': recipe.recipe,
      'favourite': recipe.favourite,
      // Add any other properties you want to save
    });

    print('Recipe saved to Firestore for user: $userName');
  } catch (e) {
    print('Error saving recipe: $e');
  }
}

Future<List<RecipeModel>> getRecipes(String userName) async {
  try {
    final userCollection = _firestore.collection('users').doc(userName);

    final querySnapshot = await userCollection.collection('recipes').get();

    final recipes = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return RecipeModel(name: data['name'], recipe: data['recipe'], favourite: data['favourite']);
    }).toList();

    return recipes;
  } catch (e) {
    print('Error getting recipes: $e');
    return [];
  }
}



class RecipeDialogResult {
  final String recipeName;
  final bool isFavorite;
  final bool isCancelled;

  RecipeDialogResult(this.recipeName, this.isFavorite, this.isCancelled);
}

Future<RecipeDialogResult?> getRecipeNameDialog(BuildContext context) async {
  return showDialog<RecipeDialogResult>(
    context: context,
    builder: (context) {
      String recipeName = '';
      bool isCancelled = false;
      bool isFavorite = false;

      return AlertDialog(
        title: Text('Enter Recipe Name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                recipeName = value;
              },
              decoration: InputDecoration(labelText: 'Recipe Name'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Mark as Favorite'),
                Checkbox(
                  value: isFavorite,
                  onChanged: (value) {
                    isFavorite = value ?? false;
                  },
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(RecipeDialogResult('', false, true));
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              print("From Save Recipe Name");
              print(recipeName);
              Navigator.of(context).pop(RecipeDialogResult(
                recipeName,
                isFavorite,
                false,
              ));
            },
          ),
        ],
      );
    },
  );
}
