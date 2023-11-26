import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

import '../../Components/alert.dart';
import '../../controller/recipe_service.dart';
import '../../controller/user_service.dart';
import '../../model/user_model.dart';

class GenerateRecipe extends StatefulWidget {
  final String userId;

  const GenerateRecipe({required this.userId, Key? key}) : super(key: key);

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

  bool _isWillingToShopForMore = false;

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
              'content':
                  'Generate a recipe ${_isWillingToShopForMore ? '' : 'only'} using ${_ingredientController.text}${userPreferences != null ? ' for a person with dietary preferences: ${userPreferences.dietaryPreferences.join(", ")}' ',intolerances: ${userPreferences.intolerances.join(", ")} and allergies: ${userPreferences.allergies.join(", ")}' : ''}. If the ingredients are not related to dietary intolerances, generate a recipe using those ingredients or else say that with ingredients you can\'t generate a recipe due to dietary intolerances.'
            },
          ],
          'temperature': 0.7, // Adjust as needed
        }),
      );

      final data = jsonDecode(response.body);
      setState(() {
        if (data != null &&
            data['choices'] != null &&
            data['choices'].isNotEmpty &&
            data['choices'][0]['message'] != null &&
            data['choices'][0]['message']['content'] != null) {
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

  @override
  Widget build(BuildContext context) {
    // Array with name for app bar header
    return Scaffold(
      floatingActionButton: Visibility(
        visible: _recipeDetails != null,
        child: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          // This is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          visible: true,
          // If true user is forced to close dial manually
          // by tapping main button and overlay is not rendered.
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.deepPurple.shade300,
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: const CircleBorder(),
          children: [
            SpeedDialChild(
              child: const Icon(
                Icons.save,
                color: Colors.white,
              ),
              backgroundColor: Colors.deepPurple.shade300,
              label: 'Save Recipe',
              labelStyle: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              labelBackgroundColor: Colors.deepPurple.shade300,
              onTap: () async {
                if (_recipeDetails != null) {
                  SavedRecipeDialogResult? result =
                      await _alert.saveRecipeAlert(context, _recipeDetails!);
                  if (result!.isSaved) {
                    _alert.successAlert(
                        context, "Successfully saved the recipe");
                  }
                } else {
                  _alert.warningAlert(context, "No recipe generated yet");
                }
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.refresh, color: Colors.white),
              backgroundColor: Colors.deepPurple.shade300,
              label: 'Regenerate Response',
              labelStyle: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              labelBackgroundColor: Colors.deepPurple.shade300,
              onTap: _generateRecipe,
            ),
          ],
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
                // Add a suffix icon for generating a new recipe
                suffixIcon: IconButton(
                  icon: _recipeDetails != null
                      ? Icon(
                          Icons.autorenew,
                          color: Colors.deepPurple.shade300,
                          size: 35,
                        )
                      : Icon(
                          Icons.search,
                          color: Colors.deepPurple.shade300,
                          size: 35,
                        ),
                  onPressed: _generateRecipe,
                ),
              ),
            ),
            const SizedBox(height: 14.0),
            CheckboxListTile(
              title: const Text("Willing to shop for more ingredients"),
              value: _isWillingToShopForMore,
              onChanged: (bool? value) {
                setState(() {
                  _isWillingToShopForMore = value ?? false;
                });
              },
              secondary: const Icon(Icons.shopping_cart),
            ),
            const SizedBox(height: 14.0),
            Visibility(
              visible: isLoading,
              child: Container(
                padding: const EdgeInsets.only(top: 100.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple.shade300,
                  ),
                ),
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
                ],
              ),
          ],
        ),
      ),
    );
  }
}
