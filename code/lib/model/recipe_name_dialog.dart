import 'package:flutter/material.dart';

Future<String?> getRecipeNameDialog(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (context) {
      String recipeName = '';

      return AlertDialog(
        title: Text('Enter Recipe Name'),
        content: TextField(
          onChanged: (value) {
            recipeName = value;
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              Navigator.of(context).pop(recipeName);
            },
          ),
        ],
      );
    },
  );
}