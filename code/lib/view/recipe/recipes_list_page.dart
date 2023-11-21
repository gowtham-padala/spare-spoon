import 'package:flutter/material.dart';
import '../../controller/recipe_service.dart';
import '../../model/recipe_model.dart';
import '../../utils/side_bar.dart';
import '../home_page.dart';
import 'recipes_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _HomePageStateMenu();
}

class SavedRecipeItem extends StatelessWidget {
  final RecipeModel recipe;

  SavedRecipeItem(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
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
                recipe.favourite
                    ? Icon(
                  Icons.star,
                  color: Colors.yellow,
                )
                    : Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                Text(
                  recipe.recipe,
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
      ),
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
  late var recipeName;
  void initState() {
    super.initState();
    // Call the method to show saved recipes initially
    _showSavedRecipes();
  }

  // Method to fetch and show saved recipes
  Future<void> _showSavedRecipes() async {
    final UserId = user?.uid;
    recipes = await getRecipes(UserId!);

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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Recipes",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[300],
      ),

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
                  onPressed: () {
                    // Use Navigator to pop the current route and return to the previous page.
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[300],
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.20, 50),
                  ),
                  child: const Text("Back"),
                ),
                Spacer(),
                Text("Filters", style:TextStyle(color:Colors.deepPurple[300])),
                SizedBox(width:10),
                ElevatedButton(
                  onPressed: () async {
                    final UserId = user?.uid;
                    recipes = await getRecipes(UserId!);
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
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.20, 50),
                  ),
                  child: const Text("Show Favourite Recipes"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final UserId = user?.uid;
                    recipes = await getRecipes(UserId!);

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
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.20, 50),
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
                  child: Card(
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListView(
                        children: [
                          for (var recipe in recipes)
                            if(recipe.favourite == true)
                            //SavedRecipeItem(recipe),
                              RecipeCard(name: recipe.name, description: recipe.recipe, favourite: recipe.favourite),
                        ],
                      ),
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
                  child: Card(
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListView(
                        children: [
                          for (var recipe in recipes)
                          //SavedRecipeItem(recipe),
                            RecipeCard(name: recipe.name, description: recipe.recipe, favourite: recipe.favourite),
                        ],
                      ),
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
                  child: Card(
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                ),

              ],
            ),
        ],
      ),

    );
  }
}

class RecipeCard extends StatefulWidget {
  final String name;
  final String description;
  late bool favourite;

  RecipeCard({
    required this.name,
    required this.description,
    required this.favourite,
    Key? key,
  }) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.deepPurple.shade300,
      child: ListTile(
        title: Text(
          widget.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              child: Icon(
                Icons.star,
                color: widget.favourite ? Colors.yellow : Colors.white,
              ),
              onTap: () {
                setState(() {
                  widget.favourite = !widget.favourite;
                });
              },
            ),
            const SizedBox(width: 12),
            GestureDetector(
              child: const Icon(Icons.delete, color: Colors.white),
              onTap: () {
                _showDeleteConfirmationDialog(context);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipesDetailsPage(
                name: widget.name,
                description: widget.description,
              ),
            ),
          );
        },
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipesDetailsPage(
                name: widget.name,
                description: widget.description,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Recipe?'),
          content: const Text('Are you sure you want to delete this recipe?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // Add the code here to delete the recipe from Firestore.
                // You may need to pass some identifier or key to identify which recipe to delete.
                // After deleting, you can use Navigator.of(context).pop() to close the dialog.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}