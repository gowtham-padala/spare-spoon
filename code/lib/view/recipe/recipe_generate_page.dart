import 'package:flutter/material.dart';

class RecipeGeneratorPage extends StatelessWidget {
  final TextEditingController ingredientController;
  final Function() generateRecipe;
  final bool isLoading;
  final String? recipe;

  RecipeGeneratorPage({
    required this.ingredientController,
    required this.generateRecipe,
    required this.isLoading,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider using Provider
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: ingredientController,
              decoration: InputDecoration(
                hintText: "Enter ingredients",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: isLoading
                  ? Container(
                      padding: const EdgeInsets.only(top: 177.0),
                      child: const CircularProgressIndicator(),
                    )
                  : ElevatedButton(
                      onPressed: generateRecipe,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.deepPurple.shade300),
                      ),
                      child: const Text("Generate Recipe"),
                    ),
            ),
            if (recipe != null)
              Column(
                children: [
                  const SizedBox(height: 32.0),
                  SizedBox(
                    height: 400,
                    child: Card(
                      color: Colors.deepPurple[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          recipe!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: generateRecipe,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.deepPurple.shade300),
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
