import 'dart:io';

import 'package:code/Components/alert.dart';
import 'package:code/controller/auth_service.dart';
import 'package:code/controller/recipe_service.dart';
import 'package:code/model/recipe_model.dart';
import 'package:code/utils/theme_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:transparent_image/transparent_image.dart';

class UpdateRecipePage extends StatefulWidget {
  final String recipeDocID;
  final RecipeModel recipeObj;

  final Function() onRecipeUpdated;

  const UpdateRecipePage(
      {required this.recipeDocID,
      required this.recipeObj,
      required this.onRecipeUpdated,
      Key? key})
      : super(key: key);

  @override
  State<UpdateRecipePage> createState() => _UpdateRecipePageState();
}

class _UpdateRecipePageState extends State<UpdateRecipePage> {
  final AuthService _auth = AuthService();
  final RecipeService _recipe = RecipeService();
  final Alert _alert = Alert();

  // State variables for updated description, rating, and date of the diary entry.
  late String _updatedDescription;
  late String _updatedCategory;
  late String _updatedTitle;
  late List<String> _updatedImages;

  // Instance of ImagePicker for picking images from gallery.
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  // Variable for Expandable floating action button
  bool isDialOpen = false;

  @override
  void initState() {
    super.initState();
    // Initialize state variables with the values from the provided diary entry.
    _updatedDescription = widget.recipeObj.details;
    _updatedTitle = widget.recipeObj.name;
    _updatedImages = widget.recipeObj.images ?? [];
    _updatedCategory = widget.recipeObj.category;
  }

  /// Function to pick images from gallery
  /// @return {Future<void>} - A future object
  Future<void> _pickImageFromGallery() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _images = images;
      });
    }
  }

  /// Function to take a picture from the camera
  Future<void> _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  /// Function to upload images to firebase storage
  /// @param {BuildContext} context - The context of the current widget.
  /// @return {List<String>} - List of image urls
  Future<List<String>> _uploadImagesToFirebase(BuildContext context) async {
    // Check if the _images list is empty
    if (_images.isEmpty) {
      return []; // or throw an error or handle accordingly
    }
    // Get the current logged in user
    String? currentLoggedInUser = await _auth.getCurrentUser()!.uid;

    try {
      // Upload the images to firebase storage
      List<String> imageUrls = [];

      for (XFile image in _images) {
        // Create a reference to the firebase storage
        final firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('images/$currentLoggedInUser/${basename(image.path)}');
        // Upload the image to firebase storage
        final uploadTask = await firebaseStorageRef.putFile(File(image.path));
        // Check if the upload is successful
        if (uploadTask.state == TaskState.success) {
          final downloadURL = await firebaseStorageRef.getDownloadURL();
          imageUrls.add(downloadURL);
        }
      }

      widget.onRecipeUpdated();

      // Assuming you want to return the first image URL
      if (imageUrls.isNotEmpty) {
        return imageUrls;
      } else {
        return []; // or handle accordingly
      }
    } catch (e) {
      _alert.errorAlert(context, "Something went wrong");
      return []; // or throw an error or handle accordingly
    }
  }

  /// Function for update recipe in the firebase.
  /// @param {BuildContext} context - The context of the current widget.
  Future<void> _updateRecipeInFirebase(BuildContext context) async {
    try {
      // Show a loading spinner dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple[300],
              ),
            ),
          );
        },
      );

      // Upload the images to firebase storage
      final List<String> imageArray;
      // Check if the _images list is empty
      if (_images.isNotEmpty) {
        imageArray = await _uploadImagesToFirebase(context);
        _updatedImages.addAll(imageArray);
      }
      // Validate the updated title and description before saving
      if (_updatedTitle.trim().isEmpty || _updatedDescription.trim().isEmpty) {
        if (_updatedTitle.trim().isEmpty) {
          _alert.warningAlert(context, "Title can't be empty");
        } else if (_updatedDescription.trim().isEmpty) {
          _alert.warningAlert(context, "Description can't be empty");
        }
      } else {
        // Create an updated RecipeModel
        RecipeModel updatedRecipe = RecipeModel(
          uid: widget.recipeObj.uid,
          name: _updatedTitle,
          details: _updatedDescription,
          category: _updatedCategory,
          isFavorite: widget.recipeObj.isFavorite,
          creationDate: widget.recipeObj.creationDate,
          // Assuming you want to update the updateDate as well
          updateDate: DateTime.now(),
          images: _updatedImages,
        );

        // Call your RecipeService to update the recipe in Firebase
        await _recipe.updateRecipe(widget.recipeDocID, updatedRecipe);

        widget.onRecipeUpdated();
        // Close the loading spinner dialog
        Navigator.of(context).pop();
        _alert.successAlert(context, "Recipe updated successfully");
      }
    } catch (err) {
      // Close the loading spinner dialog
      Navigator.of(context).pop();
      // Display an error message if the update fails
      _alert.errorAlert(
          context, "Something went wrong, please try again later");
    }
  }

  /// Function for displaying a confirmation dialog before removing an image.
  /// @param {BuildContext} context - The context of the current widget.
  /// @param {int} index - The index of the image to be removed.
  /// @return {Future<void>} - A future object
  Future<void> _confirmImageRemoval(BuildContext context, int index) async {
    try {
      // Show a confirmation dialog before removing the image
      await QuickAlert.show(
        onCancelBtnTap: () {
          Navigator.pop(context);
        },
        context: context,
        type: QuickAlertType.confirm,
        text: 'Do you want to remove this image?',
        titleAlignment: TextAlign.center,
        textAlignment: TextAlign.center,
        confirmBtnText: 'Remove',
        cancelBtnText: 'Cancel',
        confirmBtnColor: Colors.deepPurple[300]!,
        headerBackgroundColor: Colors.white,
        confirmBtnTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        cancelBtnTextStyle: const TextStyle(
          color: Colors.black, // Change the cancel button color here
        ),
        titleColor: Colors.black,
        textColor: Colors.black,
        onConfirmBtnTap: () async {
          // Remove the image from the _updatedImages list
          _updatedImages.removeAt(index);
          // Create an updated RecipeModel
          RecipeModel updatedRecipe = RecipeModel(
            uid: widget.recipeObj.uid,
            name: _updatedTitle,
            details: _updatedDescription,
            category: _updatedCategory,
            isFavorite: widget.recipeObj.isFavorite,
            creationDate: widget.recipeObj.creationDate,
            // Assuming you want to update the updateDate as well
            updateDate: DateTime.now(),
            images: _updatedImages,
          );
          ;
          await _recipe.updateRecipe(widget.recipeDocID, updatedRecipe);

          widget.onRecipeUpdated();
          // Perform sign-out logic here
          setState(() {
            Navigator.pop(context);
          });
        },
      );
    } catch (err) {
      // Display an error message if the update fails
      _alert.errorAlert(
          context, "Something went wrong, please try again later");
    }
  }

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
            backgroundColor: Colors.deepPurple.shade300,
            // App bar with back button and title for updating a diary entry.
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
            title: const Text(
              "Update Recipe",
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    await _updateRecipeInFirebase(context);
                  },
                  icon: const Icon(Icons.save_as_sharp))
            ],
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
                    Icons.save_as_sharp,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.deepPurple.shade300,
                  onTap: () async {
                    await _updateRecipeInFirebase(context);
                  },
                  label: 'Update Recipe',
                  labelBackgroundColor: Colors.deepPurple.shade300,
                  labelStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              SpeedDialChild(
                child: const Icon(
                  Icons.add_a_photo_rounded,
                  color: Colors.white,
                ),
                backgroundColor: Colors.deepPurple.shade300,
                onTap: _pickImageFromGallery,
                label: 'Add Images',
                labelBackgroundColor: Colors.deepPurple.shade300,
                labelStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SpeedDialChild(
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                backgroundColor: Colors.deepPurple.shade300,
                onTap: () async {
                  await _takePicture();
                },
                label: 'Take Picture',
                labelBackgroundColor: Colors.deepPurple.shade300,
                labelStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          body: Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              children: [
                // Text field for entering updated description with character counter.
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    TextFormField(
                      initialValue: widget.recipeObj.name,
                      onChanged: (value) {
                        setState(() {
                          _updatedTitle = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Title",
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                        ),
                        counterStyle: TextStyle(
                          decoration: null,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // Text field for entering updated description with character counter.
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    TextFormField(
                      initialValue: widget.recipeObj.category,
                      onChanged: (value) {
                        setState(() {
                          _updatedCategory = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Category",
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                        ),
                        counterStyle: TextStyle(
                          decoration: null,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: TextFormField(
                      initialValue: widget.recipeObj.details,
                      onChanged: (value) {
                        setState(() {
                          _updatedDescription = value;
                        });
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                        ),
                        counterStyle: TextStyle(
                          decoration: null,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20.0,
                ),
                // Display original and updated dates of the diary entry.
                Row(
                  children: [
                    const Text(
                      "Created At:",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd')
                          .format(widget.recipeObj.creationDate),
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // Row for selecting the updated date of the diary entry.
                Row(
                  children: [
                    const Text(
                      "Updated On:",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd')
                          .format(widget.recipeObj.updateDate),
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),

                    // Button for updating the diary entry.
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                if (_updatedImages.isNotEmpty)
                  Expanded(
                    // Set a fixed height for the GridView
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: _updatedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Stack(
                            children: [
                              FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: _updatedImages[index],
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    // Add logic here to remove the image from Firebase Storage
                                    // and update the _updatedImages list
                                    _confirmImageRemoval(context, index);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    color: Colors.red,
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                if (_images.isNotEmpty)
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Stack(
                            children: [
                              Image.file(
                                File(_images[index].path),
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _images.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    color: Colors.red,
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                // Button for updating the diary entry.
              ],
            ),
          ),
        ));
  }
}
