// Importing necessary packages and files
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './common_recipe_details_page.dart';
import '../../controller/common_recipe_service.dart';
import '../../model/common_recipe_model.dart';

// Creating a stateful widget for the CommonRecipesPage
class CommonRecipesPage extends StatefulWidget {
  const CommonRecipesPage({Key? key}) : super(key: key);

  @override
  State<CommonRecipesPage> createState() => _CommonRecipesPageState();
}

// State class for the CommonRecipesPage
class _CommonRecipesPageState extends State<CommonRecipesPage> {
  // State variables
  bool isLoading = false;
  List<CommonRecipeModel> commonRecipes = [];
  final CommonRecipeService _commonRecipeService = CommonRecipeService();

  // Method called when the state is initialized
  @override
  void initState() {
    super.initState();
    _loadCommonRecipes(); // Loading common recipes when the page is initialized
  }

  // Asynchronous method to load common recipes
  Future<void> _loadCommonRecipes() async {
    setState(() {
      isLoading = true; // Setting loading state to true
    });
    commonRecipes = await _commonRecipeService
        .getCommonRecipes(); // Fetch common recipes from the service

    if (mounted) {
      // Checking if the widget is still part of the widget tree before setting state
      setState(() {
        isLoading = false; // Setting loading state to false
      });
    }
  }

  // Building method to create the UI for the CommonRecipesPage
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show a loading indicator if data is still loading
          : Column(
              children: [
                // Adding the title text with a badge-like border
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade300, // Background color
                      border: Border.all(
                        color: Colors.deepPurple.shade200,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: const Text(
                      "Deliciously Recommended Recipes!",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.3),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      // Displaying recipe cards in a ListView
                      for (var recipe in commonRecipes)
                        GestureDetector(
                          onTap: () {
                            _navigateToRecipeDetails(
                                recipe); // Navigate to recipe details page on tap
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // Method to navigate to the recipe details page
  void _navigateToRecipeDetails(CommonRecipeModel recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommonRecipeDetailsPage(
          commonRecipe: recipe,
          userId: FirebaseAuth.instance.currentUser?.uid ??
              '', // Passing current user's ID to the details page
        ),
      ),
    );
  }
}
