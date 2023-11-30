import 'package:flutter/material.dart';

/// Class for recipe dialog result.
class RecipeDialogResult {
  final String recipeName;
  final bool isFavorite;
  final bool isCancelled;

  RecipeDialogResult(this.recipeName, this.isFavorite, this.isCancelled);
}

/// Function to show the recipe name dialog.
/// @param context The context of the application.
Future<RecipeDialogResult?> getRecipeNameDialog(BuildContext context) async {
  return showDialog<RecipeDialogResult>(
    context: context,
    builder: (context) {
      String recipeName = '';
      bool isCancelled = false;
      bool isFavorite = false;

      return AlertDialog(
        title: const Text('Enter Recipe Name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                recipeName = value;
              },
              decoration: const InputDecoration(labelText: 'Recipe Name'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Mark as Favorite'),
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
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(RecipeDialogResult('', false, true));
            },
          ),
          TextButton(
            child: const Text('Save'),
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
