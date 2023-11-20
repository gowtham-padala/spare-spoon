import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/model/recipe_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> saveRecipe(RecipeModel recipe) async {
  try {
    await _firestore.collection('recipes').add({
      'name': recipe.name, // Save the name property
      'recipe': recipe.recipe,
      'favourite': recipe.favourite,
      // Add any other properties you want to save
    });
    print('Recipe saved to Firestore');
  } catch (e) {
    print('Error saving recipe: $e');
  }
}

Future<List<RecipeModel>> getRecipes() async {
  final querySnapshot = await _firestore.collection('recipes').get();
  print('after collection');
  final recipes = querySnapshot.docs.map((doc) {
    //print('map entered');
    final data = doc.data();
    //print("data is ");
    //print(data);
    return RecipeModel(name: data['name'], recipe: data['recipe'], favourite: data['favourite']);
  }).toList();
  //print('recipes returned');
  return recipes;
}

