import 'dart:convert';

import 'package:code/controller/pdf_service.dart';
import 'package:code/model/recipe_model.dart';
import 'package:code/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipesDetailsPage extends StatefulWidget {
  final String recipeDocID;
  final RecipeModel recipeObj;

  const RecipesDetailsPage(
      {required this.recipeDocID, required this.recipeObj, Key? key})
      : super(key: key);

  @override
  State<RecipesDetailsPage> createState() => _RecipesDetailsPageState();
}

class _RecipesDetailsPageState extends State<RecipesDetailsPage> {
  // Initialized the variable to check if the app is generating pdf or not
  bool _isGeneratingPdf = false;
  // Variable for Expandable floating action button
  bool isDialOpen = false;
  // Initializing variable for downloading pdf services
  final PdfService _pdfService = PdfService();

  Future<void> _generateShoppingList(RecipeModel recipeObj) async {
    setState(() {
      _isGeneratingPdf = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization':
              'Bearer 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',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-4-0613',
          'messages': [
            {
              'role': 'user',
              'content':
                  'Generate a shopping list for the following recipe: ${recipeObj.details}'
            },
          ],
          'temperature': 0.7,
        }),
      );
      final data = jsonDecode(response.body);
      if (data != null &&
          data['choices'] != null &&
          data['choices'].isNotEmpty &&
          data['choices'][0]['message'] != null &&
          data['choices'][0]['message']['content'] != null) {
        final shoppingList = data['choices'][0]['message']['content'].trim();
        await _pdfService.generateAndSaveShoppingListPDF(
            recipeObj, shoppingList);
      }
    } catch (e) {
      // Handle exception
    } finally {
      setState(() {
        _isGeneratingPdf = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          backgroundColor: Colors.deepPurple[300],
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => setState(() => isDialOpen = true),
          onClose: () => setState(() => isDialOpen = false),
          children: [
            SpeedDialChild(
                child: const Icon(
                  Icons.download,
                  color: Colors.white,
                ),
                backgroundColor: Colors.deepPurple.shade300,
                onTap: () async {
                  setState(() {
                    _isGeneratingPdf = true;
                  });
                  await _pdfService.generateAndSavePDF(widget.recipeObj);
                  setState(() {
                    _isGeneratingPdf = false;
                  });
                },
                label: 'Save as PDF',
                labelBackgroundColor: Colors.deepPurple.shade300,
                labelStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            SpeedDialChild(
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              backgroundColor: Colors.deepPurple.shade300,
              onTap: () async {
                if (!_isGeneratingPdf) {
                  _generateShoppingList(widget.recipeObj);
                }
              },
              label: 'Generate Shopping List',
              labelBackgroundColor: Colors.deepPurple.shade300,
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        body: Stack(children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Displaying the name of the common recipe with a larger font and bold style
                Text(
                  widget.recipeObj.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.recipeObj.category,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        widget.recipeObj.details,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (widget.recipeObj != null &&
                    widget.recipeObj.images != null &&
                    widget.recipeObj.images!.isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: widget.recipeObj.images!.length,
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
                                image: widget.recipeObj.images![index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          if (_isGeneratingPdf)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
