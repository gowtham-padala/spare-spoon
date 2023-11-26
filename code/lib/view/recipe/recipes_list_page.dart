import 'package:code/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../components/recipe_card.dart';
import '../../controller/recipe_service.dart';
import '../../model/recipe_model.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  // Initializing the variable for loading screen
  bool isLoading = true;
  // Initializing the empty recipes
  List<RecipeModel> recipes = [];
  // Variable for viewing all and saved recipes
  bool showSavedRecipes = false;
  bool showFavouriteRecipes = false;
  // Initiating controllers for authentication and recipe
  final AuthService _auth = AuthService();
  final RecipeService _recipeService = RecipeService();
  // Variable for Expandable floating action button
  bool isDialOpen = false;

  @override
  void initState() {
    super.initState();
    // Call the method to show saved recipes initially
    _showSavedRecipes();
  }

  // Method to fetch and show saved recipes
  Future<void> _showSavedRecipes() async {
    recipes =
        await _recipeService.getAllRecipesForAUser(_auth.getCurrentUser()!.uid);
    if (mounted) {
      setState(() {
        isLoading = false;
        showSavedRecipes = true;
        showFavouriteRecipes = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22.0),
        backgroundColor: Colors.deepPurple[300],
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => setState(() => isDialOpen = true),
        onClose: () => setState(() => isDialOpen = false),
        children: [
          SpeedDialChild(
              child: const Icon(
                Icons.star,
                color: Colors.white,
              ),
              backgroundColor: Colors.deepPurple.shade300,
              onTap: () async {
                recipes = await _recipeService
                    .getAllFavoriteRecipesForAUser(_auth.getCurrentUser()!.uid);
                if (mounted) {
                  setState(() {
                    showFavouriteRecipes = true;
                    showSavedRecipes = false;
                  });
                }
              },
              label: 'Show Favourite Recipes',
              labelBackgroundColor: Colors.deepPurple.shade300,
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          SpeedDialChild(
            child: const Icon(
              Icons.bookmark,
              color: Colors.white,
            ),
            backgroundColor: Colors.deepPurple.shade300,
            onTap: () async {
              recipes = await _recipeService
                  .getAllRecipesForAUser(_auth.getCurrentUser()!.uid);
              if (mounted) {
                setState(() {
                  showFavouriteRecipes = false;
                  showSavedRecipes = true;
                });
              }
            },
            label: 'Show All Saved Recipes',
            labelBackgroundColor: Colors.deepPurple.shade300,
            labelStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(1.0),
        children: [
          if (isLoading)
            Container(
              padding: const EdgeInsets.only(top: 300.0),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple.shade300,
                ),
              ),
            ),
          if (!isLoading && showFavouriteRecipes)
            Column(
              children: [
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView(
                      children: [
                        for (var recipe in recipes)
                          if (recipe.isFavorite == true)
                            RecipeCard(
                              recipeDocID: recipe.id!,
                              recipe: recipe,
                              onRecipeUpdated: _showSavedRecipes,
                            )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          if (!isLoading && showSavedRecipes)
            Column(
              children: [
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView(
                      children: [
                        for (var recipe in recipes)
                          RecipeCard(
                            recipeDocID: recipe.id!,
                            recipe: recipe,
                            onRecipeUpdated: _showSavedRecipes,
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
