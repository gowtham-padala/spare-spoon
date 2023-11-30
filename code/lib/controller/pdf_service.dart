import 'dart:io';

import 'package:code/model/recipe_model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

/// Service class for PDF-related operations.
class PdfService {
  Future<void> generateAndSavePDF(RecipeModel recipeObj) async {
    final pdf = pw.Document();
    // Use the custom font
    final pw.Font customFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
    // Logo to be what is used in the PDF
    final logo = await rootBundle.load('assets/spare_spoon_logo.png');
    // Logo to be used in the PDF
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
                pw.SizedBox(width: 20),
                pw.Text(recipeObj.name.toUpperCase(),
                    style: pw.TextStyle(font: customFont, fontSize: 32))
              ]),
            ),
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 10), // Add some space
                  pw.Text(
                    'Details: ${recipeObj.details}',
                    style: pw.TextStyle(font: customFont),
                  ),
                  // Add other details as needed
                ]),
          ]);
        },
      ),
    );

    // Add images to the PDF
    for (var imageUrl in recipeObj.images!) {
      final response = await http.get(Uri.parse(imageUrl));
      final Uint8List imageBytes = response.bodyBytes;
      // Add the image to the PDF document
      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(children: [
              pw.Header(
                level: 0,
                child: pw.Row(children: [
                  pw.Image(pw.MemoryImage(logoByte), width: 180, height: 100),
                  pw.SizedBox(width: 20),
                  pw.Text(recipeObj.name.toUpperCase(),
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
    final directory = await getTemporaryDirectory();
    // Path to the PDF file
    final filePath = '${directory.path}/recipe_details.pdf';
    // Create the file
    final file = File(filePath);
    // Write the PDF to the file
    await file.writeAsBytes(await pdf.save());
    // Open the generated PDF file
    OpenFile.open(filePath);
  }

  /// Function to generate and save the shopping list PDF
  Future<void> generateAndSaveShoppingListPDF(
      RecipeModel recipeObj, String shoppingList) async {
    // Variable to store the PDF
    final pdf = pw.Document();
    // Setting up the custom font
    final pw.Font customFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
    // Setting up the logo
    final logo = await rootBundle.load('assets/spare_spoon_logo.png');
    final logoByte = logo.buffer.asUint8List();
    // Adding the shopping list to the PDF
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(children: [
            pw.Header(
              level: 0,
              child: pw.Row(children: [
                pw.Image(pw.MemoryImage(logoByte), width: 180, height: 100),
                pw.SizedBox(width: 20),
                pw.Text(recipeObj.name.toUpperCase(),
                    style: pw.TextStyle(font: customFont, fontSize: 32))
              ]),
            ),
            pw.SizedBox(height: 10),
            pw.Text(shoppingList,
                style: pw.TextStyle(font: customFont, fontSize: 24)),
          ]);
        },
      ),
    );
    // Initializing the directory
    final directory = await getTemporaryDirectory();
    // Adding the temporary path to the PDF file
    final filePath = '${directory.path}/shopping_list.pdf';
    // Getting the file path
    final file = File(filePath);
    // Writing the PDF to the file
    await file.writeAsBytes(await pdf.save());
    // Opening the generated PDF file
    OpenFile.open(filePath);
  }
}
