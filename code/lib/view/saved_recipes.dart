import 'package:flutter/material.dart';
import '../model/recipe_model.dart';



class SavedRecipesPage extends StatelessWidget {
  final List<RecipeModel> savedRecipes;

  SavedRecipesPage(this.savedRecipes);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Recipes'),
      ),

      body: ListView.builder(
        itemCount: savedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = savedRecipes[index];
          return ListTile(
            title: Text(recipe.name),
            subtitle: Text(recipe.recipe),
            // Add any additional data you want to display
          );
        },
      ),
    );
  }


}
