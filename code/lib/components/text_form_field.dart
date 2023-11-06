import 'package:flutter/material.dart';

/// Custom text field widget that can be used to input text.
class CustomTextField extends StatelessWidget {
  final TextEditingController
      controller; // Controller for managing the text input.
  final String
      hintText; // Hint text displayed inside the text field when it is empty.
  final String label; // Label for the input field
  final bool
      obscureText; // Determines whether the text input should be obscured (e.g., for passwords).
  final IconButton iconButton;
  final bool? isPasswordHidden;

  /// Constructor for MyTextField widget.
  /// [controller] is a required parameter, a controller for managing the text input.
  /// [hintText] is a required parameter, the hint text displayed inside the text field.
  /// [obscureText] is a required parameter, a boolean indicating whether the input should be obscured.
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.label,
    required this.iconButton,
    this.isPasswordHidden,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:
          controller, // Assigns the provided controller to the TextField.
      obscureText: obscureText,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return '$label is empty';
        }
        return null;
      }, // Determines whether the input is obscured.
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple.shade300),
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: hintText, // Sets the provided hint text for the text field.
        hintStyle: TextStyle(color: Colors.grey[700]), // Hint text style.
        labelText: label,
        suffixIcon: iconButton,
      ),
    );
  }
}
