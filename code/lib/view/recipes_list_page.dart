import 'package:flutter/material.dart';
import './recipes_detail_page.dart';

class RecipesListPage extends StatelessWidget {
  const RecipesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Recipes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[850],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: const RecipeCard(
              name: 'Recipe 1',
              description:
                  "Ingredients: Chicken Yogurt, lemon juice, spices (cumin, coriander, turmeric, paprika, garam masala, chili powder, ginger, garlic) Onion, tomato, cream/coconut milk, oil, salt Instructions: Marinate and grill chicken. Sauté onion, spices, add tomato, and cream/coconut milk. Simmer and add grilled chicken. Garnish and serve with rice or naan. Ingredients: Chicken Yogurt, lemon juice, spices (cumin, coriander, turmeric, paprika, garam masala, chili powder, ginger, garlic) Onion, tomato, cream/coconut milk, oil, salt Instructions: Marinate and grill chicken. Sauté onion, spices, add tomato, and cream/coconut milk. Simmer and add grilled chicken. Garnish and serve with rice or naan",
            ),
          ),
          const RecipeCard(name: 'Recipe 2', description: 'Description 1'),
        ],
      ),
    );
  }
}

class RecipeCard extends StatefulWidget {
  final String name;
  final String description;

  const RecipeCard({
    required this.name,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isStarClicked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.grey[700],
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
                isStarClicked ? Icons.star : Icons.star_border,
                color: isStarClicked ? Colors.teal : null,
              ),
              onTap: () {
                setState(() {
                  isStarClicked = !isStarClicked;
                });
              },
            ),
            const SizedBox(width: 12),
            GestureDetector(
              child: const Icon(Icons.delete, color: Colors.red),
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
