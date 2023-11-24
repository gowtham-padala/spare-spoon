import 'package:flutter/material.dart';

import '../view/recipe/recipes_detail_page.dart';

class RecipeCard extends StatefulWidget {
  final String name;
  final String description;
  late bool favourite;

  RecipeCard({
    required this.name,
    required this.description,
    required this.favourite,
    Key? key,
  }) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.deepPurple.shade300,
      child: ListTile(
        title: Text(
          widget.name,
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
                color: widget.favourite ? Colors.yellow : Colors.white,
              ),
              onTap: () {
                setState(() {
                  widget.favourite = !widget.favourite;
                });
              },
            ),
            const SizedBox(width: 12),
            GestureDetector(
              child: const Icon(Icons.delete, color: Colors.white),
              onTap: () {
                _showDeleteConfirmationDialog(context);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipesDetailsPage(
                name: widget.name,
                description: widget.description,
              ),
            ),
          );
        },
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipesDetailsPage(
                name: widget.name,
                description: widget.description,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Recipe?'),
          content: const Text('Are you sure you want to delete this recipe?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // Add the code here to delete the recipe from Firestore.
                // You may need to pass some identifier or key to identify which recipe to delete.
                // After deleting, you can use Navigator.of(context).pop() to close the dialog.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
