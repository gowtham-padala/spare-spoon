import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../view/recipe/recipes_list_page.dart';

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
                    backgroundColor: Colors.white,
                    child: Icon(
                      color: Colors.black54,
                      Icons.person,
                      size: 60,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade300,
                    image: const DecorationImage(
                      image: AssetImage("assets/sidebar_food_image.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListTile(
                  leading:
                      Icon(Icons.person, color: Colors.deepPurple.shade300),
                  title: Text('Profile Management',
                      style: TextStyle(color: Colors.deepPurple.shade300)),
                  onTap: () {
                    // Navigating to the profile management screen
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.restaurant, color: Colors.deepPurple.shade300),
                  title: Text('Recipes',
                      style: TextStyle(color: Colors.deepPurple.shade300)),
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
                  leading:
                      Icon(Icons.settings, color: Colors.deepPurple.shade300),
                  title: Text('Settings',
                      style: TextStyle(color: Colors.deepPurple.shade300)),
                  onTap: () {
                    // Navigating to the settings screen
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.close, color: Colors.redAccent.shade400),
            title: Text('Close Sidebar',
                style: TextStyle(color: Colors.redAccent.shade400)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
