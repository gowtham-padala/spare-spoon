// Importing necessary packages and local views
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../view/recipe/recipes_list_page.dart';
import '../view/profile/profile_management_page.dart';

// Sidebar widget for the application
class Sidebar extends StatelessWidget {
  final User? user; // The authenticated user
  const Sidebar({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Main container for the sidebar
      child: Column(
        children: [
          Expanded(
            // Expanded section containing user details and menu options
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // User header section
                UserAccountsDrawerHeader(
                  accountName: Text(
                    user?.email.toString() ?? "", // Displaying user email
                    style: const TextStyle(color: Colors.white),
                  ),
                  accountEmail: const Text(
                    "Member since: Jan 2023", // Placeholder for member since
                    style: TextStyle(color: Colors.white),
                  ),
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
                // Menu options
                ListTile(
                  leading:
                      Icon(Icons.person, color: Colors.deepPurple.shade300),
                  title: Text('Profile Management',
                      style: TextStyle(color: Colors.deepPurple.shade300)),
                  onTap: () {
                    // Navigating to the profile management screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileManagementPage(userId: user?.uid ?? ""),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.restaurant, color: Colors.deepPurple.shade300),
                  title: Text('Recipes',
                      style: TextStyle(color: Colors.deepPurple.shade300)),
                  onTap: () {
                    // Navigating to the recipes screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //builder: (context) => const RecipesListPage(),
                        builder: (context) => const RecipesPage(),
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
                    // Placeholder for navigating to the settings screen
                  },
                ),
              ],
            ),
          ),
          // Close Sidebar option
          ListTile(
            leading: Icon(Icons.close, color: Colors.redAccent.shade400),
            title: Text('Close Sidebar',
                style: TextStyle(color: Colors.redAccent.shade400)),
            onTap: () {
              // Closing the sidebar
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
