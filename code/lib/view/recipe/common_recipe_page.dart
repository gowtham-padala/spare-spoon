// Importing necessary packages and files
import 'package:code/Components/alert.dart';
import 'package:code/controller/auth_service.dart';
import 'package:code/controller/recipe_service.dart';
import 'package:code/model/recipe_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

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
  List<CommonRecipeModel> originalCommonRecipes = [];
  final CommonRecipeService _commonRecipeService = CommonRecipeService();

  // Controller for the search bar
  final TextEditingController _searchController =
      TextEditingController(); // Focus node for the search bar
  final FocusNode _searchFocusNode = FocusNode();

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
    originalCommonRecipes = commonRecipes;
    if (mounted) {
      // Checking if the widget is still part of the widget tree before setting state
      setState(() {
        isLoading = false; // Setting loading state to false
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
                    _loadCommonRecipes();
                  } else {
                    List<CommonRecipeModel> filteredList = [];
                    originalCommonRecipes.forEach((recipe) {
                      if (recipe.name
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          recipe.category
                              .toLowerCase()
                              .contains(value.toLowerCase())) {
                        filteredList.add(recipe);
                      }
                    });

                    commonRecipes = filteredList;
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
                      _loadCommonRecipes();
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
        "No recipes available, stay tuned for new recipes".toUpperCase(),
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    ),
  );

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
                originalCommonRecipes.isNotEmpty
                    ? searchBarWidget()
                    : noRecipeWidget,
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
                    padding: const EdgeInsets.all(10.0),
                    children: [
                      // Displaying recipe cards in a ListView
                      for (var recipe in commonRecipes)
                        InkWell(
                          onTap: () {
                            _navigateToRecipeDetails(
                                recipe); // Navigate to recipe details page on tap
                          },
                          child: Card(
                            // Set the shape of the card using a rounded rectangle border with an 8 pixel radius
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // Set the clip behavior of the card
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            // Define the child widgets of the card

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  recipe.image != null &&
                                          recipe.image!.isNotEmpty
                                      ? recipe.image!
                                      : 'https://firebasestorage.googleapis.com/v0/b/flutterauth-ff1a9.appspot.com/o/foods_cropped.jpg?alt=media&token=cb053cda-417c-46d2-b076-e59d4675458f',
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // Display the card's title (category) using a font size of 24 and a dark grey color
                                      // Add some spacing between the top of the card and the title
                                      Container(height: 5),
                                      // Add a title widget
                                      Text(
                                        recipe.name.trim().isEmpty
                                            ? "No Name"
                                            : recipe.name.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // Add some spacing between the title and the subtitle
                                      Container(height: 5),
                                      // Add a subtitle widget
                                      Text(
                                        recipe.name.trim().isEmpty
                                            ? "No Category"
                                            : recipe.category,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      // Add some spacing between the subtitle and the text
                                      Container(height: 10),

                                      // Display the card's sub-header (details) using a font size of 15 and a light grey color
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        DateFormat('MMMM dd, yyyy')
                                            .format(recipe.creationDate),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 1.5),
                                      ),
                                      // Add a spacer to push the buttons to the right side of the card
                                      const Spacer(),
                                      InkWell(
                                        onTap: () async {
                                          await Alert().ratingUpdateAlert(
                                              context,
                                              recipe,
                                              _loadCommonRecipes);
                                        },
                                        child: RatingBar.builder(
                                          initialRating:
                                              recipe.rating.toDouble(),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 18,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.yellow.shade600,
                                          ),
                                          onRatingUpdate: (rating) {
                                            // Empty function, no action needed
                                          },
                                        ),
                                      ),

                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          // Creating a new recipe model based on the common recipe
                                          RecipeModel newRecipe = RecipeModel(
                                            uid: AuthService()
                                                .getCurrentUser()!
                                                .uid,
                                            name: recipe.name,
                                            details: recipe.description,
                                            category: recipe.category,
                                            images: [recipe.image!],
                                            isFavorite: false,
                                            creationDate: DateTime.now(),
                                            updateDate: DateTime.now(),
                                          );

                                          // Adding the new recipe to the user's collection
                                          await RecipeService()
                                              .addRecipe(newRecipe);

                                          // Showing a confirmation dialog using the custom alert component
                                          if (context.mounted) {
                                            Alert().successAlert(
                                              context,
                                              'The recipe has been saved to your collection',
                                            );
                                          }
                                        },
                                        child: const Icon(
                                          Icons.save_alt,
                                        ),
                                      ),

                                      // Add a GestureDetector for the star icon
                                    ],
                                  ),
                                ),
                              ],
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
