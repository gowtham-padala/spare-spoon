import 'package:hive/hive.dart';

part 'recipe_model.g.dart'; // This will be generated

@HiveType(typeId: 0)
class RecipeModel {
  final String name;
  final String recipe;
  @HiveField(0)

  RecipeModel({required this.recipe, required this.name});
}