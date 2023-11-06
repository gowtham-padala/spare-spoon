import 'dart:convert';

import 'package:code/controller/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

import '../utils/side_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  final TextEditingController _ingredientController = TextEditingController();
  String? _recipe;
  bool isLoading = false;

  Future<void> _generateRecipe() async {
    setState(() {
      isLoading = true;
      _recipe = null; // Removing the previous response
    });

    final response = await http.post(
      Uri.parse(
          'https://api.openai.com/v1/engines/text-davinci-003/completions'),
      headers: {
        'Authorization':
            'Bearer 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',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': 'Generate a recipe using ${_ingredientController.text}',
        'max_tokens': 1000, // Limiting to our requirement
      }),
    );

    final data = jsonDecode(response.body);
    setState(() {
      _recipe = data['choices'][0]['text'].trim();
      isLoading = false;
    });
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    await QuickAlert.show(
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to logout',
      titleAlignment: TextAlign.center,
      textAlignment: TextAlign.center,
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
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
        // Perform sign-out logic here
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      drawer: Sidebar(user: user),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _ingredientController,
                decoration: InputDecoration(
                  hintText: "Enter ingredients",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: isLoading
                    ? Container(
                        padding: const EdgeInsets.only(top: 177.0),
                        child: const CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: _generateRecipe,
                        child: const Text("Generate Recipe"),
                      ),
              ),
              if (_recipe != null)
                Column(
                  children: [
                    const SizedBox(height: 32.0),
                    SizedBox(
                      height: 400,
                      child: Card(
                        color: Colors.deepPurple[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _recipe!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: _generateRecipe,
                        child: const Text("Regenerate Response"),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
