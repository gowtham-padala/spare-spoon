import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _ingredientController = TextEditingController();
  String? _recipe;


  Future<void> _generateRecipe() async {
    // Here, you'd make the call to OpenAI's API
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/engines/text-davinci-003/completions'),
      headers: {
        'Authorization': 'Bearer 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',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': 'Generate a recipe using ${_ingredientController.text}',
        'max_tokens': 200,  // Limit to your requirement
      }),
    );


    final data = jsonDecode(response.body);
    setState(() {
      _recipe = data['choices'][0]['text'].trim();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[850],
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user!.email.toString(), style: const TextStyle(color: Colors.white)),
              accountEmail: const Text("Member since: Jan 2023", style: TextStyle(color: Colors.white)),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text("User"),
              ),
              decoration: BoxDecoration(
                color: Colors.grey[850],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.white),
              title: const Text('Notifications', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigation logic if needed
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigation logic if needed
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ingredientController,
              decoration: const InputDecoration(
                hintText: "Enter ingredients",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _generateRecipe,
              child: const Text("Generate Recipe"),
            ),
            const SizedBox(height: 16.0),
            if (_recipe != null) Text(_recipe!, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
