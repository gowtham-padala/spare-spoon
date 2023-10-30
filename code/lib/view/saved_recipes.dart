import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/recipe_model.dart';


class SavedRecipesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Recipes'),
      ),
      body: FutureBuilder(
        future: Hive.openBox<RecipeModel>('recipes'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final box = Hive.box<RecipeModel>('recipes');
              final recipes = box.values.toList();

              if (recipes.isEmpty) {
                return Center(child: Text('No recipes saved.'));
              }

              return ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return ListTile(
                    title: Text(recipe.recipe),
                  );
                },
              );
            } else {
              return Center(child: Text('No recipes saved.'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}