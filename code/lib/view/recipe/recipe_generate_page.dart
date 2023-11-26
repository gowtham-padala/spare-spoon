import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
                          child: const Text(
                            "GENERATE RECIPE",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
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
                ],
              ),
          ],
        ),
      ),
    );
  }
}
