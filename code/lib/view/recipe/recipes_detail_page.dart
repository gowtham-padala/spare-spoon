import 'package:code/model/recipe_model.dart';
import 'package:code/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipesDetailsPage extends StatelessWidget {
  final String recipeDocID;
  final RecipeModel recipeObj;

  const RecipesDetailsPage(
      {required this.recipeDocID, required this.recipeObj, Key? key})
      : super(key: key);

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
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
            backgroundColor: Colors.deepPurple.shade300,
            title: const Center(
              child: Text(
                'Recipe Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Card(
                      color: Colors.deepPurple.shade300,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(recipeObj.name,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 20),
                            const Text(
                              'How Do I Make It?',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 400,
                    child: Card(
                      color: Colors.deepPurple.shade300,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            recipeObj.details,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (recipeObj.images!.isNotEmpty)
                    SizedBox(
                      height: 300,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: recipeObj.images!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Card(
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1.0),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: recipeObj.images![index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  // Add more details here about how to make the recipe
                ],
              ),
            ),
          ),
        ));
  }
}
