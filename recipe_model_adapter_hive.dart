import 'package:code/model/recipe_model.dart';
import 'package:hive/hive.dart';
import 'recipe_model.dart';

class RecipeModelHiveAdapter extends TypeAdapter<RecipeModel> {
  @override
  final int typeId = 0; // Unique identifier for your model

  @override
  RecipeModel read(BinaryReader reader) {
    final recipe = reader.read() as String;
    return RecipeModel(name: '', recipe: recipe);
  }

  @override
  void write(BinaryWriter writer, RecipeModel obj) {
    writer.write(obj.recipe);
  }
}