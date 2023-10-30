import 'package:hive/hive.dart';

part 'recipe_model.g.dart'; // This will be generated

@HiveType(typeId: 0)
class RecipeModel {
  @HiveField(0)
  final String recipe;

  RecipeModel(this.recipe);
}