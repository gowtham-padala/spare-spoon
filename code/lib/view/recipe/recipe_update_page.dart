import 'package:code/Components/alert.dart';
import 'package:code/controller/auth_service.dart';
import 'package:code/controller/recipe_service.dart';
import 'package:code/model/recipe_model.dart';
import 'package:code/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateRecipePage extends StatefulWidget {
  final String recipeDocID;
  final RecipeModel recipeObj;

  const UpdateRecipePage(
      {required this.recipeDocID, required this.recipeObj, Key? key})
      : super(key: key);

  @override
  State<UpdateRecipePage> createState() => _UpdateRecipePageState();
}

class _UpdateRecipePageState extends State<UpdateRecipePage> {
  final AuthService _auth = AuthService();
  final RecipeService _recipe = RecipeService();
  final Alert _alert = Alert();
  // State variables for updated description, rating, and date of the diary entry.
  late String _updatedDescription;
  late String _updatedTitle;
  late List<String> _updatedImages;

  @override
  void initState() {
    super.initState();
    // Initialize state variables with the values from the provided diary entry.
    _updatedDescription = widget.recipeObj.details;
    _updatedTitle = widget.recipeObj.name;
  }

  Future<void> _updateRecipeInFirebase(BuildContext context) async {
    try {
      // Show a loading spinner dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple[300],
              ),
            ),
          );
        },
      );

      // Validate the updated title and description before saving
      if (_updatedTitle.trim().isEmpty || _updatedDescription.trim().isEmpty) {
        if (_updatedTitle.trim().isEmpty) {
          _alert.warningAlert(context, "Title can't be empty");
        } else if (_updatedDescription.trim().isEmpty) {
          _alert.warningAlert(context, "Description can't be empty");
        }
      } else {
        // Create an updated RecipeModel
        RecipeModel updatedRecipe = RecipeModel(
          uid: widget.recipeObj.uid,
          name: _updatedTitle,
          details: _updatedDescription,
          isFavorite: widget.recipeObj.isFavorite,
          creationDate: widget.recipeObj.creationDate,
          // Assuming you want to update the updateDate as well
          updateDate: DateTime.now(),
        );

        // Call your RecipeService to update the recipe in Firebase
        await _recipe.updateRecipe(widget.recipeDocID, updatedRecipe);
        // Close the loading spinner dialog
        Navigator.of(context).pop();
        _alert.successAlert(context, "Recipe updated successfully");
      }
    } catch (err) {
      // Close the loading spinner dialog
      Navigator.of(context).pop();
      // Display an error message if the update fails
      _alert.errorAlert(
          context, "Something went wrong, please try again later");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider using Provider
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Theme(
        data: ThemeData(
          brightness:
              themeProvider.darkTheme ? Brightness.dark : Brightness.light,
          // Add other theme properties as needed
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple.shade300,
            // App bar with back button and title for updating a diary entry.
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
            title: const Text(
              "Update Diary Entry",
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await _updateRecipeInFirebase(context);
                },
                icon: const Icon(Icons.save),
                tooltip: "Update Recipe",
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  // Text field for entering updated description with character counter.
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      TextFormField(
                        initialValue: widget.recipeObj.name,
                        onChanged: (value) {
                          setState(() {
                            _updatedTitle = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(
                            fontSize: 20.0,
                          ),
                          counterStyle: TextStyle(
                            decoration: null,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 400,
                    child: Expanded(
                      child: SingleChildScrollView(
                        child: TextFormField(
                          initialValue: widget.recipeObj.details,
                          onChanged: (value) {
                            setState(() {
                              _updatedDescription = value;
                            });
                          },
                          maxLines:
                              null, // Set maxLines to null for unlimited lines
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            labelText: "Description",
                            labelStyle: TextStyle(
                              fontSize: 20.0,
                            ),
                            counterStyle: TextStyle(
                              decoration: null,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20.0,
                  ),
                  // Display original and updated dates of the diary entry.
                  Row(
                    children: [
                      const Text(
                        "Created At:",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd')
                            .format(widget.recipeObj.creationDate),
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Row for selecting the updated date of the diary entry.
                  Row(
                    children: [
                      const Text(
                        "Updated On:",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd')
                            .format(widget.recipeObj.updateDate),
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  // Button for updating the diary entry.
                ],
              ),
            ),
          ),
        ));
  }
}
