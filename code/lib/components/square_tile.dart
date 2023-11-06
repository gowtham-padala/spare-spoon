import 'package:flutter/material.dart';

/// Custom square tile widget displaying an image.
class SquareTile extends StatelessWidget {
  final String imagePath; // Path to the image asset used in the tile.
  final Function()?
      onTap; // Callback function triggered when the tile is tapped.

  /// Constructor for SquareTile widget.
  /// [imagePath] is a required parameter, the path to the image asset displayed in the tile.
  /// [onTap] is a required parameter, a function to be executed when the tile is tapped.
  const SquareTile({Key? key, required this.imagePath, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap, // Assigns the onTap callback function to the GestureDetector.
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Image.asset(
          imagePath, // Loads the image from the provided image path.
          height: 40, // Sets the height of the displayed image.
        ),
      ),
    );
  }
}
