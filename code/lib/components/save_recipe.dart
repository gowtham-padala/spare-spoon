import 'package:flutter/material.dart';

import '../model/recipe_model.dart';

/// Widget class for save the recipe item.
class SavedRecipeItem extends StatelessWidget {
  // Initialize the recipe object.
  final RecipeModel recipe;
  // Constructor for the recipe item.
  const SavedRecipeItem(this.recipe, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  recipe.name,
                  style: const TextStyle(color: Colors.blue),
                ),
                recipe.isFavorite
                    ? const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      )
                    : const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                Text(
                  recipe.details,
                  style: const TextStyle(color: Colors.black),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement your functionality here (e.g., delete or edit the recipe).
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[300],
                  ),
                  child: const Text("Edit Recipe"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
