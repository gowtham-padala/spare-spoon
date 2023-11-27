import 'package:code/Components/alert.dart';
import 'package:code/controller/recipe_service.dart';
import 'package:code/model/recipe_model.dart';
import 'package:code/view/recipe/recipe_update_page.dart';
import 'package:flutter/material.dart';

import '../view/recipe/recipes_detail_page.dart';

class RecipeCard extends StatefulWidget {
  final String recipeDocID;
  final RecipeModel recipe;
  final Function() onRecipeUpdated;

  RecipeCard({
    required this.recipeDocID,
    required this.recipe,
    required this.onRecipeUpdated,
    Key? key,
  }) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    Alert alert = Alert();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.deepPurple.shade300,
      child: ListTile(
        leading:
            widget.recipe.images != null && widget.recipe.images!.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(widget.recipe.images![0]),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade400,
                    // Placeholder image or empty if no images available
                    child: const Icon(
                      Icons.food_bank_outlined,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
        title: Text(
          widget.recipe.name,
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
                color: widget.recipe.isFavorite ? Colors.yellow : Colors.white,
              ),
              onTap: () async {
                setState(() {
                  RecipeModel updatedRecipeModel = RecipeModel(
                      uid: widget.recipe.uid,
                      name: widget.recipe.name,
                      details: widget.recipe.details,
                      isFavorite: !widget.recipe.isFavorite,
                      creationDate: widget.recipe.creationDate,
                      updateDate: widget.recipe.updateDate);
                  RecipeService()
                      .updateRecipe(widget.recipe.id!, updatedRecipeModel);
                  widget.recipe.isFavorite = !widget.recipe.isFavorite;
                  widget.onRecipeUpdated();
                });
              },
            ),
            const SizedBox(width: 12),
            GestureDetector(
              child: const Icon(Icons.delete, color: Colors.white),
              onTap: () async {
                await alert.showRecipeDeleteConfirmationDialog(
                    context, widget.recipeDocID);
                widget.onRecipeUpdated();
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipesDetailsPage(
                recipeDocID: widget.recipeDocID,
                recipeObj: widget.recipe,
              ),
            ),
          );
        },
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateRecipePage(
                recipeDocID: widget.recipeDocID,
                recipeObj: widget.recipe,
              ),
            ),
          );
        },
      ),
    );
  }
}
