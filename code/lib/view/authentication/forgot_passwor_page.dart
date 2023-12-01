import 'package:code/components/alert.dart';
import 'package:code/controller/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/text_form_field.dart';

/// Widget class for the forgot password page.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Authentication service instance
  final AuthService _auth = AuthService();

  // Text editing controller for email input field
  final emailController = TextEditingController();

  // Error messaging class instance
  final Alert _alert = Alert();

  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  @override
  void dispose() {
    // Dispose of the text editing controller when the widget is removed from the tree
    emailController.dispose();
    super.dispose();
  }

  // Function to handle password reset
  Future passwordReset() async {
    // Show loading dialog while processing the password reset request
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          key: _keyLoader, // Use the GlobalKey for the dialog
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurple[300],
            ),
          ),
        );
      },
    );

    try {
      // Attempt to send a password reset email
      await _auth.passwordReset(emailController.text.trim());
      // Dismiss the loading dialog before showing the success modal
      Navigator.pop(context);
      _alert.successAlert(context, "Successfully sent password reset email");
    } on FirebaseAuthException catch (err) {
      // Dismiss the loading dialog on error
      Navigator.pop(context);

      // Handle specific error cases and display appropriate error messages
      if (err.code == "user-not-found") {
        _alert.errorAlert(context, "No user found for that email");
      } else if (err.code == "wrong-password") {
        _alert.errorAlert(context, "Please provide a valid password");
      } else if (emailController.text.trim().isEmpty) {
        _alert.warningAlert(context, "Please provide a valid email address");
      } else {
        _alert.errorAlert(
            context, "Something went wrong, please contact support team");
      }
      return; // Return early to avoid popping the context again
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App bar title
        title: const Text(
          "Forgot Password",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      // Body of the forgot password screen
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Instructional text for the user
            const SizedBox(height: 100),
            // Logo
            Icon(
              Icons.food_bank_outlined,
              size: 100,
              color: Colors.deepPurple[300],
            ),
            const SizedBox(height: 25),
            Text(
              'Spare Spoon',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Enter your email and we will send you a password reset link",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Email input field
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomTextField(
                controller: emailController,
                label: "Email",
                hintText: 'hello@sparespoon.com',
                iconButton: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.email,
                    color: Colors.deepPurple[300],
                  ),
                ),
                obscureText: false,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Button to initiate password reset
            MaterialButton(
              onPressed: passwordReset,
              color: Colors.deepPurple[300],
              child: const Text(
                "Reset Password",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
