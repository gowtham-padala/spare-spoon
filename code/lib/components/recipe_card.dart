import 'package:code/Components/alert.dart';
import 'package:code/controller/recipe_service.dart';
import 'package:code/model/recipe_model.dart';
import 'package:code/view/recipe/recipe_update_page.dart';
import 'package:code/view/recipe/recipes_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      // Set the shape of the card using a rounded rectangle border with an 8 pixel radius
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      // Set the clip behavior of the card
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // Define the child widgets of the card
      child: InkWell(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Display an image at the top of the card that fills the width of the card and has a height of 160 pixels
            Image.network(
              widget.recipe.images != null && widget.recipe.images!.isNotEmpty
                  ? widget.recipe.images![0]
                  : 'https://firebasestorage.googleapis.com/v0/b/flutterauth-ff1a9.appspot.com/o/foods_cropped.jpg?alt=media&token=cb053cda-417c-46d2-b076-e59d4675458f',
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            // Add a container with padding that contains the card's title and subheader
            Container(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the card's title (category) using a font size of 24 and a dark grey color
                  // Add some spacing between the top of the card and the title
                  Container(height: 5),
                  // Add a title widget
                  Text(
                    widget.recipe.name.toUpperCase() ?? "No Name",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  // Add some spacing between the title and the subtitle
                  Container(height: 5),
                  // Add a subtitle widget
                  Text(
                    widget.recipe.category ?? "No Category",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  // Add some spacing between the subtitle and the text
                  Container(height: 10),

                  // Display the card's subheader (details) using a font size of 15 and a light grey color
                ],
              ),
            ),
            // Add a row with two buttons spaced apart and aligned to the right side of the card
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    DateFormat('MMMM dd, yyyy')
                        .format(widget.recipe.creationDate),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.5),
                  ),
                  // Add a spacer to push the buttons to the right side of the card
                  const Spacer(),
                  // Add a GestureDetector for the star icon
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        RecipeModel updatedRecipeModel = RecipeModel(
                          uid: widget.recipe.uid,
                          name: widget.recipe.name,
                          details: widget.recipe.details,
                          category: widget.recipe.category,
                          isFavorite: !widget.recipe.isFavorite,
                          creationDate: widget.recipe.creationDate,
                          images: widget.recipe.images,
                          updateDate: widget.recipe.updateDate,
                        );
                        RecipeService().updateRecipe(
                            widget.recipe.id!, updatedRecipeModel);
                        widget.recipe.isFavorite = !widget.recipe.isFavorite;
                        widget.onRecipeUpdated();
                      });
                    },
                    child: Icon(
                      Icons.star,
                      color: widget.recipe.isFavorite
                          ? Colors.deepPurple.shade300
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Add a GestureDetector for the delete icon
                  GestureDetector(
                    onTap: () async {
                      await alert.showRecipeDeleteConfirmationDialog(
                        context,
                        widget.recipeDocID,
                      );
                      widget.onRecipeUpdated();
                    },
                    child: const Icon(
                      Icons.delete,
                    ),
                  ),
                ],
              ),
            ),
            // Add a small space between the card and the next widget
            Container(height: 5),
          ],
        ),
      ),
    );
  }
}
