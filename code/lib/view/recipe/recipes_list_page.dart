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
  List<RecipeModel> originalAllRecipes = [];
  List<RecipeModel> originalAllFavoriteRecipe = [];
  List<RecipeModel> favoriteRecipes = [];

  // Variable for viewing all and saved recipes
  bool showSavedRecipes = false;
  bool showFavouriteRecipes = false;
  // Initiating controllers for authentication and recipe
  final AuthService _auth = AuthService();
  final RecipeService _recipeService = RecipeService();
  // Variable for Expandable floating action button
  bool isDialOpen = false;
  // Controller for the search bar
  final TextEditingController _searchController =
      TextEditingController(); // Focus node for the search bar
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Call the method to show saved recipes initially
    _showSavedRecipes();
    _showFavoriteRecipes();
  }

  // Method to fetch and show saved recipes
  Future<void> _showSavedRecipes() async {
    recipes =
        await _recipeService.getAllRecipesForAUser(_auth.getCurrentUser()!.uid);
    originalAllRecipes = recipes;
    if (mounted) {
      setState(() {
        isLoading = false;
        showSavedRecipes = true;
        showFavouriteRecipes = false;
      });
    }
  }

  // Method to fetch and show saved recipes
  Future<void> _showFavoriteRecipes() async {
    favoriteRecipes = await _recipeService
        .getAllFavoriteRecipesForAUser(_auth.getCurrentUser()!.uid);
    originalAllFavoriteRecipe = favoriteRecipes;
    if (mounted) {
      setState(() {
        isLoading = false;
        showSavedRecipes = true;
        showFavouriteRecipes = false;
      });
    }
  }

  /// Widget searchBarWidget displays a search bar for searching diary entries by rating or description.
  Widget searchBarWidget() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (value) {
                // Handle search logic here
                setState(() {
                  if (value.toLowerCase().trim().isEmpty) {
                    if (showFavouriteRecipes) {
                      _showFavoriteRecipes();
                    } else if (showSavedRecipes) {
                      _showSavedRecipes();
                    }
                  } else {
                    List<RecipeModel> filteredList = [];
                    if (showSavedRecipes) {
                      originalAllRecipes.forEach((recipe) {
                        if (recipe.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            recipe.category
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          filteredList.add(recipe);
                        }
                      });
                    } else if (showFavouriteRecipes) {
                      originalAllFavoriteRecipe.forEach((recipe) {
                        if (recipe.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            recipe.category
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          filteredList.add(recipe);
                        }
                      });
                    }
                    recipes = filteredList;
                  }
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by name or category...',
                prefixIcon: Icon(
                  Icons.search,
                  color:
                      Colors.deepPurple.shade300, // Set the search icon color
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color:
                        Colors.deepPurple.shade300, // Set the clear icon color
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _searchFocusNode.unfocus();
                    setState(() {
                      _showFavoriteRecipes();
                      _showSavedRecipes();
                    });
                  },
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.deepPurple
                        .shade300, // Set the border color when focused
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.deepPurple
                        .shade300, // Set the border color when not focused
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Widget for displaying a message when there are no available months
  Widget noRecipeWidget = Padding(
    padding: const EdgeInsets.fromLTRB(8.0, 300.0, 8.0, 8.0),
    child: Center(
      child: Text(
        "No recipes available, please add new recipes".toUpperCase(),
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    ),
  );

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
              onTap: () {
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
            onTap: () {
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
      body: Column(
        children: [
          originalAllRecipes.isNotEmpty ? searchBarWidget() : noRecipeWidget,
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(1.0),
              children: [
                Visibility(
                  visible: isLoading,
                  child: Container(
                    padding: const EdgeInsets.only(top: 300.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple.shade300,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isLoading && showFavouriteRecipes,
                  child: Column(
                    children: [
                      if (originalAllRecipes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors
                                  .deepPurple.shade300, // Background color
                              border: Border.all(
                                color: Colors.deepPurple.shade200,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: const Text(
                              "Favourite Recipe",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.3),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        height: 500,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListView(
                            children: [
                              for (var recipe in favoriteRecipes)
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
                ),
                Visibility(
                  visible: !isLoading && showSavedRecipes,
                  child: Column(
                    children: [
                      if (originalAllRecipes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors
                                  .deepPurple.shade300, // Background color
                              border: Border.all(
                                color: Colors.deepPurple.shade200,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: const Text(
                              "All Saved Recipe",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.3),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        height: 500,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
