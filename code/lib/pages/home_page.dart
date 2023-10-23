import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final user = FirebaseAuth.instance.currentUser;

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
              accountName: Text(user!.email.toString(), style: TextStyle(color: Colors.white)),
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
    );
  }
}
