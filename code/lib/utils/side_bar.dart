// Importing necessary packages and local views
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Sidebar widget for the application
class Sidebar extends StatelessWidget {
  final User? user;
  final int selectedIndex;
  final Function(int) updateSelectedIndex;

  const Sidebar(
      {super.key,
      required this.user,
      required this.selectedIndex,
      required this.updateSelectedIndex});

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
                  leading: Icon(Icons.home, color: Colors.deepPurple.shade300),
                  title: Text(
                    'Home',
                    style: TextStyle(
                      color: selectedIndex == 0
                          ? Colors.deepPurple.shade300
                          : Colors.black, // Highlight if selected
                    ),
                  ),
                  onTap: () {
                    updateSelectedIndex(0);
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading:
                      Icon(Icons.restaurant, color: Colors.deepPurple.shade300),
                  title: Text(
                    'Recipes',
                    style: TextStyle(
                      color: selectedIndex == 1
                          ? Colors.deepPurple.shade300
                          : Colors.black, // Highlight if selected
                    ),
                  ),
                  onTap: () {
                    updateSelectedIndex(1);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.person, color: Colors.deepPurple.shade300),
                  title: Text(
                    'Profile Management',
                    style: TextStyle(
                      color: selectedIndex == 2
                          ? Colors.deepPurple.shade300
                          : Colors.black, // Highlight if selected
                    ),
                  ),
                  onTap: () {
                    updateSelectedIndex(2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.settings, color: Colors.deepPurple.shade300),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      color: selectedIndex == 3
                          ? Colors.deepPurple.shade300
                          : Colors.black, // Highlight if selected
                    ),
                  ),
                  onTap: () {
                    updateSelectedIndex(3);
                    Navigator.pop(context);
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
