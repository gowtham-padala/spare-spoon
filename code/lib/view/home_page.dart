import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/model/save_recipe.dart';
import 'package:code/view/recipe/recipes_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../model/recipe_model.dart';
import '../utils/side_bar.dart';
import 'dart:convert';
import 'saved_recipes.dart';
import '../model/recipe_name_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class SavedRecipeItem extends StatelessWidget {
  final RecipeModel recipe;

  SavedRecipeItem(this.recipe);

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

class _HomePageState extends State<HomePage> {
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



  Future<void> _generateRecipe() async {
    setState(() {
      isLoading = true;
      _recipe = null; // Removing the previous response
    });

    final response = await http.post(
      Uri.parse(
          'https://api.openai.com/v1/engines/text-davinci-003/completions'),
      headers: {
        'Authorization':
        'Bearer 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',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': 'Generate a recipe using ${_ingredientController.text}',
        'max_tokens': 1000, // Limiting to our requirement
      }),
    );

    final data = jsonDecode(response.body);
    setState(() {
      _recipe = data['choices'][0]['text'].trim();
      isLoading = false;
    });
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Do you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[300],
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),

      drawer: Sidebar(user: user),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ingredientController,
              decoration: InputDecoration(
                hintText: "Enter ingredients",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 14.0),
            Expanded(
              child: Center(
                child: isLoading
                    ? Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: const CircularProgressIndicator(),
                )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      ElevatedButton(
                        onPressed: _generateRecipe,
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[300],
                            minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 50),
                      ),
                        child: const Text("Generate Recipe"),
                    ),
                          SizedBox(height: 10),
                      ElevatedButton(
                      onPressed: () async {

                        recipes = await getRecipes();

                        // Setting the flag to show saved recipes.
                        if (mounted) {
                          setState(() {
                            showFavouriteRecipes = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[300],
                          minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 50),
                      ),
                      child: const Text("Show Favourite Recipes"),
                    ),
                          SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {

                        recipes = await getRecipes();

                        // Setting the flag to show saved recipes.
                        if (mounted) {
                          setState(() {
                            showSavedRecipes = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[300],
                          minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 50),
                      ),
                      child: const Text("Show Saved Recipes"),
                    ),
                  ],
                ),
              ),
            ),
            /*
            ElevatedButton(
              onPressed: () async {

                recipes = await getRecipes();

                // Setting the flag to show saved recipes.
                if (mounted) {
                  setState(() {
                    showFavouriteRecipes = true;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[300],
              ),
              child: const Text("Show Favourite Recipes"),
            ),
             */
            if (showFavouriteRecipes)
              Column(
                children: [
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showFavouriteRecipes = false;
                        showSavedRecipes = false; // showSavedRecipes is a boolean state variable
                      });
                    },
                    child: Text("Close"),
                  ),
                  SizedBox(
                    height: 400,
                    child: Card(
                      color: Colors.grey[800],
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
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showFavouriteRecipes = false;
                        showSavedRecipes = false; // showSavedRecipes is a boolean state variable
                      });
                    },
                    child: Text("Close"),
                  ),
                  SizedBox(
                    height: 400,
                    child: Card(
                      color: Colors.grey[800],
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
                      color: Colors.grey[800],
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
                            ElevatedButton(
                              onPressed: () async {
                                final recipeName;
                                if (_recipe != null) {
                                  RecipeDialogResult? result = await getRecipeNameDialog(context);
                                  //final recipeName = await getRecipeNameDialog(context);
                                  if (result != null && !result.isCancelled) {
                                    recipeName = result.recipeName;
                                    final isFavourite = result.isFavorite;
                                    if(recipeName != null){
                                      recipeModel = RecipeModel(name: recipeName, recipe: _recipe!, favourite: isFavourite);
                                      saveRecipe(recipeModel!);
                                    }
                                    setState(() {
                                      savedRecipes.add(recipeModel!);
                                    });

                                  } else {
                                    print('User canceled the dialog');
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple[300],
                              ),
                              child: const Text("Save Recipe"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: _generateRecipe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text("Regenerate Response"),
                    ),
                  ),

                ],
              ),

          ],
        ),
      ),
    );
  }
}
