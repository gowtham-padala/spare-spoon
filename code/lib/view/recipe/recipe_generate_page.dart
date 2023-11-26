import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Components/alert.dart';
import '../../controller/auth_service.dart';
import '../../controller/recipe_service.dart';
import '../../controller/user_service.dart';
import '../../model/user_model.dart';

class GenerateRecipe extends StatefulWidget {
  final String userId;

  const GenerateRecipe({required this.userId, Key? key})
      : super(key: key);

  @override
  State<GenerateRecipe> createState() => _GenerateRecipeState();
}

class _GenerateRecipeState extends State<GenerateRecipe> {
  // Controller for handling user-related operations.
  late UserService userController;
  // Initializing the ingredient controller text box
  final TextEditingController _ingredientController = TextEditingController();
  // Initialize the variable to store recipe details
  String? _recipeDetails;
  // Initialized the variable to check if the app is in loading screen or not
  bool isLoading = false;
  // Index of the selected page
  int selectedPageIndex = 0;
  // Initializing alert variable to handle custom alert pop up
  final Alert _alert = Alert();

  Future<void> _generateRecipe() async {
    setState(() {
      isLoading = true;
      _recipeDetails = null; // Removing the previous response
    });

    userController = UserService(widget.userId);
    UserModel? userPreferences = await userController.getUserData();

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization':
              'Bearer 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',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-4-0613',
          'messages': [
            {
            'role': 'user',
            'content': 'Generate a recipe only using ${_ingredientController.text}${userPreferences != null ? 
                      ' for a person with dietary preferences: ${userPreferences.dietaryPreferences.join(", ")}' ' and intolerances: ${userPreferences.intolerances.join(", ")}' : ''}. If the ingredients are not related to dietary intolerances, generate a recipe only using those ingredients or else say that with ingredients you can\'t generate a recipe due to dietary intolerances.'
            },
          ],
          'temperature': 0.7, // Adjust as needed
        }),
      );

      final data = jsonDecode(response.body);
      setState(() {
        if (data != null && data['choices'] != null && data['choices'].isNotEmpty && data['choices'][0]['message'] != null && data['choices'][0]['message']['content'] != null) {
          _recipeDetails = data['choices'][0]['message']['content'].trim();
        } else {
          _recipeDetails = 'Sorry, I could not generate a recipe.';
        }
      });
    } catch (e) {
      setState(() {
        _recipeDetails = 'An error occurred: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
