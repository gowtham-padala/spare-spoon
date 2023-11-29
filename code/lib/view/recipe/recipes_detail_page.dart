import 'dart:io';

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
  State<RecipesDetailsPage> createState() => _RecipesDetailsPageState();
}

class _RecipesDetailsPageState extends State<RecipesDetailsPage> {
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

    // Add images to the PDF
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
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory?.path}/recipe_details.pdf';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(filePath); // Open the generated PDF file
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
        body: SingleChildScrollView(
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _generateAndSavePDF(widget.recipeObj);
          },
          backgroundColor: Colors.deepPurple.shade300,
          tooltip: 'Save as PDF',
          child: const Icon(Icons.picture_as_pdf),
        ),
      ),
    );
  }
}
