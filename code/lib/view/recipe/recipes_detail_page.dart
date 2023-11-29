import 'dart:io';
import 'dart:convert';

import 'package:code/model/recipe_model.dart';
import 'package:code/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipesDetailsPage extends StatefulWidget {
  final String recipeDocID;
  final RecipeModel recipeObj;

  const RecipesDetailsPage(
      {required this.recipeDocID, required this.recipeObj, Key? key})
      : super(key: key);

  @override
  _RecipesDetailsPageState createState() => _RecipesDetailsPageState();
}

class _RecipesDetailsPageState extends State<RecipesDetailsPage> {
  bool _isGeneratingPdf = false;

  Future<void> _generateAndSavePDF(RecipeModel recipeObj) async {
    final pdf = pw.Document();
    // Use the custom font
    final pw.Font customFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));

    final logo = await rootBundle.load('assets/spare_spoon_logo.png');
    final logoByte = logo.buffer.asUint8List();

    // Add recipe details to the PDF
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(children: [
            pw.Header(
              level: 0,
              child: pw.Row(children: [
                pw.Image(pw.MemoryImage(logoByte), width: 180, height: 100),
                pw.SizedBox(width: 80),
                pw.Text(widget.recipeObj.name.toUpperCase(),
                    style: pw.TextStyle(font: customFont, fontSize: 32))
              ]),
            ),
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 10), // Add some space
                  pw.Text(
                    'Details: ${widget.recipeObj.details}',
                    style: pw.TextStyle(font: customFont),
                  ),
                  // Add other details as needed
                ]),
          ]);
        },
      ),
    );

    for (var imageUrl in widget.recipeObj.images!) {
      final response = await http.get(Uri.parse(imageUrl));
      final Uint8List imageBytes = response.bodyBytes;

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(children: [
              pw.Header(
                level: 0,
                child: pw.Row(children: [
                  pw.Image(pw.MemoryImage(logoByte), width: 180, height: 100),
                  pw.SizedBox(width: 80),
                  pw.Text(widget.recipeObj.name.toUpperCase(),
                      style: pw.TextStyle(font: customFont, fontSize: 32))
                ]),
              ),
              pw.Image(
                pw.MemoryImage(imageBytes),
                width: 100,
                height: 100,
              ),
            ]);
          },
        ),
      );
    }

    // Save the PDF to a file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/recipe_details.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(filePath);
  }

  Future<void> _generateAndSaveShoppingListPDF(String shoppingList) async {
    final pdf = pw.Document();
    final pw.Font customFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
    
    final logo = await rootBundle.load('assets/spare_spoon_logo.png');
    final logoByte = logo.buffer.asUint8List();

    pdf.addPage(
      
      pw.Page(
        build: (context) {
          return pw.Column(children: [
            pw.Header(
                level: 0,
                child: pw.Row(children: [
                  pw.Image(pw.MemoryImage(logoByte), width: 180, height: 100),
                  pw.SizedBox(width: 80),
                  pw.Text(widget.recipeObj.name.toUpperCase(),
                      style: pw.TextStyle(font: customFont, fontSize: 32))
                ]),
            ),
            pw.SizedBox(height: 10),
            pw.Text(shoppingList, style: pw.TextStyle(font: customFont, fontSize: 24)),
          ]);
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/shopping_list.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(filePath);
  }

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
        await _generateAndSaveShoppingListPDF(shoppingList);
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
        brightness: themeProvider.darkTheme ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
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
                          Text(widget.recipeObj.name,
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
                          widget.recipeObj.details,
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
                if (widget.recipeObj.images!.isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                await _generateAndSavePDF(widget.recipeObj);
              },
              backgroundColor: Colors.deepPurple.shade300,
              tooltip: 'Save as PDF',
              child: const Icon(Icons.picture_as_pdf),
            ),
            SizedBox(width: 20),
            FloatingActionButton(
              onPressed: () async {
                if (!_isGeneratingPdf) {
                  _generateShoppingList(widget.recipeObj);
                }
              },
              backgroundColor: Colors.green,
              tooltip: 'Generate Shopping List',
              child: _isGeneratingPdf
                  ? CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.shopping_cart),
            ),
          ],
        ),
      ),
    );
  }
}
