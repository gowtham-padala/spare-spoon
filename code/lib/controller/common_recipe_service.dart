import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/model/common_recipe_model.dart';

class CommonRecipeService {
  final CollectionReference commonRecipeCollection =
      FirebaseFirestore.instance.collection('common_recipes');

  Future<List<CommonRecipeModel>> getCommonRecipes() async {
    var querySnapshot = await commonRecipeCollection.get();
    List<CommonRecipeModel> commonRecipes = [];

    for (var doc in querySnapshot.docs) {
      var entry = CommonRecipeModel.fromMap(doc);
      commonRecipes.add(entry);
    }
    return commonRecipes;
  }
}
