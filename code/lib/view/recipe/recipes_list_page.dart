import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/recipe_card.dart';
import '../../controller/recipe_service.dart';
import '../../model/recipe_model.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _HomePageStateMenu();
}

class SavedRecipeItem extends StatelessWidget {
  final RecipeModel recipe;

  const SavedRecipeItem(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                style: const TextStyle(color: Colors.blue),
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
    );
  }
}

class _HomePageStateMenu extends State<RecipesPage> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _ingredientController = TextEditingController();
  String? _recipe;
  bool isLoading = false;
  List<RecipeModel> savedRecipes = [];
  RecipeModel? recipeModel;
  var recipes;
  bool showSavedRecipes = false;
  bool showFavouriteRecipes = false;

  final RecipeService _recipeService = RecipeService();

  late var recipeName;
  void initState() {
    super.initState();
    // Call the method to show saved recipes initially
    _showSavedRecipes();
  }

  // Method to fetch and show saved recipes
  Future<void> _showSavedRecipes() async {
    final UserId = user?.uid;
    recipes = await _recipeService.getAllRecipesForAUser(UserId!);

    if (mounted) {
      setState(() {
        showSavedRecipes = true;
        showFavouriteRecipes = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: Sidebar(user: user),

      body: ListView(
        padding: const EdgeInsets.all(1.0),
        children: [
          Center(
            child: isLoading
                ? Container(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: const CircularProgressIndicator(),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final UserId = user?.uid;
                          recipes = await _recipeService
                              .getAllRecipesForAUser(UserId!);
                          // Setting the flag to show saved recipes.
                          if (mounted) {
                            setState(() {
                              showFavouriteRecipes = true;
                              showSavedRecipes = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[300],
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.20, 50),
                        ),
                        child: const Text("Show Favourite Recipes"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final UserId = user?.uid;
                          recipes = await _recipeService
                              .getAllRecipesForAUser(UserId!);

                          // Setting the flag to show saved recipes.
                          if (mounted) {
                            setState(() {
                              showSavedRecipes = true;
                              showFavouriteRecipes = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[300],
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.20, 50),
                        ),
                        child: const Text("Show Saved Recipes"),
                      ),
                    ],
                  ),
          ),
          if (showFavouriteRecipes)
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
                          if (recipe.favourite == true)
                            //SavedRecipeItem(recipe),
                            RecipeCard(
                                name: recipe.name,
                                description: recipe.recipe,
                                favourite: recipe.favourite),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          if (showSavedRecipes)
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
                          //SavedRecipeItem(recipe),
                          RecipeCard(
                              name: recipe.name,
                              description: recipe.recipe,
                              favourite: recipe.favourite),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          if (_recipe != null)
            Column(
              children: [
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 400,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          _recipe!,
                          style: const TextStyle(color: Colors.blue),
                        ),
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
