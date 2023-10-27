import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../view/recipes_list_page.dart';
import '../view/profile_management_page.dart';

class Sidebar extends StatelessWidget {
  final User? user;
  const Sidebar({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    user?.email.toString() ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                  accountEmail: const Text("Member since: Jan 2023",
                      style: TextStyle(color: Colors.white)),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text("User"),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    image: const DecorationImage(
                      image: AssetImage("assets/sidebar_food_image.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: const Text('Profile Management',
                      style: TextStyle(color: Colors.teal)),
                  onTap: () {
                    // Navigating to the recipes screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.restaurant, color: Colors.blue),
                  title: const Text('Recipes',
                      style: TextStyle(color: Colors.teal)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecipesListPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.blue),
                  title: const Text('Settings',
                      style: TextStyle(color: Colors.teal)),
                  onTap: () {
                    // Navigating to the settings screen
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.close, color: Colors.red),
            title: const Text('Close Sidebar',
                style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
