import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Components/alert.dart';
import '../../controller/auth_service.dart';
import '../../controller/recipe_service.dart';

class GenerateRecipe extends StatefulWidget {
  const GenerateRecipe({super.key});

  @override
  State<GenerateRecipe> createState() => _GenerateRecipeState();
}

class _GenerateRecipeState extends State<GenerateRecipe> {
  // Initializing the ingredient controller text box
  final TextEditingController _ingredientController = TextEditingController();
  // Initialize the variable to store recipe details
  String? _recipeDetails;
  // Initialized the variable to check if the app is in loading screen or not
  bool isLoading = false;
  // Initialized the variable to handle authentication related request
  final AuthService _auth = AuthService();
  // Initialized the variable to handle recipe related request
  final RecipeService _recipeService = RecipeService();
  // Index of the selected page
  int selectedPageIndex = 0;
  // Initializing alert variable to handle custom alert pop up
  final Alert _alert = Alert();
  Future<void> _generateRecipe() async {
    setState(() {
      isLoading = true;
      _recipeDetails = null; // Removing the previous response
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
      _recipeDetails = data['choices'][0]['text'].trim();
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
    // Array with name for app bar header
    return Scaffold(
      floatingActionButton: Visibility(
        visible: _recipeDetails != null,
        child: FloatingActionButton(
          backgroundColor: Colors.deepPurple.shade300,
          onPressed: () async {
            if (_recipeDetails != null) {
              SavedRecipeDialogResult? result =
                  await _alert.saveRecipeAlert(context, _recipeDetails!);
              if (result!.isSaved) {
                _alert.successAlert(context, "Successfully saved the recipe");
              }
            } else {
              _alert.warningAlert(context, "No recipe generated yet");
            }
          },
          child: const Icon(Icons.save),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ingredientController,
              decoration: InputDecoration(
                hintText: "Enter ingredients",
                filled: true,
                focusColor: Colors.deepPurple.shade300,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 14.0),
            Center(
              child: isLoading
                  ? Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple.shade300,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: _generateRecipe,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple[300],
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.95, 50),
                          ),
                          child: const Text("Generate Recipe"),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
            ),
            if (_recipeDetails != null)
              Column(
                children: [
                  const SizedBox(height: 20.0),
                  SizedBox(
                    height: 400,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              _recipeDetails!,
                              style: const TextStyle(color: Colors.black),
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
                        backgroundColor: Colors.deepPurple[300],
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
