// Importing necessary packages and files
import 'package:code/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/alert.dart';
import '../../controller/recipe_service.dart';
import '../../model/common_recipe_model.dart';
import '../../model/recipe_model.dart';

// Stateless widget to display details of a common recipe
class CommonRecipeDetailsPage extends StatelessWidget {
  final CommonRecipeModel
      commonRecipe; // The common recipe to display details for
  final RecipeService _recipeService =
      RecipeService(); // Instance of RecipeService to handle recipe-related actions
  final String userId; // User ID to associate the saved recipe with
  final Alert _alert =
      Alert(); // Instance of custom alert for displaying success messages

  // Constructor to initialize the CommonRecipeDetailsPage
  CommonRecipeDetailsPage(
      {required this.commonRecipe, required this.userId, Key? key})
      : super(key: key);

  // Building method to create the UI for the CommonRecipeDetailsPage
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Theme(
      data: ThemeData(
        brightness:
            themeProvider.darkTheme ? Brightness.dark : Brightness.light,
        // Add other theme properties as needed
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
            ),
          ),
          backgroundColor: Colors.deepPurple.shade300,
          title: const Text(
              'Common Recipe Details'), // Setting the title for the app bar
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Displaying the name of the common recipe with a larger font and bold style
              Text(
                commonRecipe.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Displaying the description of the common recipe
              Text(
                commonRecipe.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              // Button to save the common recipe to the user's recipe collection
              ElevatedButton(
                onPressed: () async {
                  // Creating a new recipe model based on the common recipe
                  RecipeModel newRecipe = RecipeModel(
                    uid: userId,
                    name: commonRecipe.name,
                    details: commonRecipe.description,
                    category: commonRecipe.category,
                    isFavorite: false,
                    creationDate: DateTime.now(),
                    updateDate: DateTime.now(),
                  );

                  // Adding the new recipe to the user's collection
                  await _recipeService.addRecipe(newRecipe);

                  // Showing a confirmation dialog using the custom alert component
                  if (context.mounted) {
                    _alert.successAlert(
                      context,
                      'The recipe has been saved to your collection',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade300),
                child: const Text('Save to My Recipes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
