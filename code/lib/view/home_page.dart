import 'dart:convert';

import 'package:code/Components/alert.dart';
import 'package:code/controller/auth_service.dart';
import 'package:code/utils/theme_provider.dart';
import 'package:code/view/profile/profile_management_page.dart';
import 'package:code/view/profile/settings_page.dart';
import 'package:code/view/recipe/recipe_generate_page.dart';
import 'package:code/view/recipe/recipes_list_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../utils/side_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Initializing variable for _auth services
  final AuthService _auth = AuthService();
  // Text editing controller for the generate recipe field
  final TextEditingController _ingredientController = TextEditingController();
  // Index of the selected page
  int selectedPageIndex = 0;
  // Initializing the _recipe variable for storing recipes
  String? _recipe;
  // Variable to tell if we are in the loading state
  bool isLoading = false;
  // Initializing alert variable to handle custom alert pop up
  final Alert _alert = Alert();

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

  final PageController _pageController = PageController();

  void updateSelectedIndex(int index) {
    setState(() {
      selectedPageIndex = index;
    });
    // Use PageController to navigate to the selected page
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize current loggedIN user
    final user = _auth.getCurrentUser();

    // Array with name for app bar header
    final List<String> appBarName = [
      "Home",
      "Recipes",
      "Profile Management",
      "Settings"
    ];
    // Initializing the variable for app bar title
    String appBarTitle = appBarName[selectedPageIndex];

    // Array containing the list of pages
    final List<Widget> pages = [
      GenerateRecipe(),
      const RecipesPage(),
      ProfileManagementPage(userId: user?.uid ?? ""),
      const SettingsPage(),
    ]; // Access the ThemeProvider using Provider
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Theme(
        data: ThemeData(
          brightness:
          themeProvider.darkTheme ? Brightness.dark : Brightness.light,
          // Add other theme properties as needed
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple.shade300,
            centerTitle: true,
            title: Text(
              appBarTitle,
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  _alert.showLogoutConfirmationDialog(context);
                },
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
              ),
            ],
          ),
          drawer: Sidebar(
            user: user,
            selectedIndex: selectedPageIndex,
            updateSelectedIndex: updateSelectedIndex,
          ),
          body: PageView(
            controller: _pageController,
            children: pages,
            onPageChanged: (index) {
              setState(() {
                selectedPageIndex = index;
              });
            },
          ),
          bottomNavigationBar: Container(
            color: Colors.deepPurple.shade300,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: GNav(
                gap: 8,
                backgroundColor: Colors.deepPurple.shade300,
                color: Colors.white54,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.white38,
                padding: const EdgeInsets.all(16),
                onTabChange: (index) {
                  setState(() {
                    selectedPageIndex = index;
                    // Set the appBarTitle based on the selected index
                    appBarTitle = appBarName[index];
                  });

                  // Use PageController to navigate to the selected page
                  _pageController.jumpToPage(index);
                },
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: "Home",
                  ),
                  GButton(
                    icon: Icons.food_bank,
                    text: "Recipes",
                  ),
                  GButton(
                    icon: Icons.person,
                    text: "Profile",
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: "Settings",
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}