import 'package:code/Components/alert.dart';
import 'package:code/controller/auth_service.dart';
import 'package:code/controller/user_service.dart';
import 'package:code/model/user_model.dart';
import 'package:code/utils/data.dart';
import 'package:code/utils/theme_provider.dart';
import 'package:code/view/chat/customer_support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Widget class for the settings page.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Initializing variable for _auth services
  final AuthService _auth = AuthService();

  // Initializing alert variable to handle custom alert pop up
  final Alert _alert = Alert();

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider using Provider
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Function to change the background color of the app
    onChangeDarkTheme(bool newValue) {
      themeProvider
          .setDarkTheme(newValue); // Set the dark theme in ThemeProvider
    }

    // Function to create button with toggle switch
    Padding buildSettingOption(
        String title, bool value, Function onChangeMethod) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                activeColor: Colors.deepPurple.shade300,
                trackColor: Colors.grey,
                value: value,
                onChanged: (bool newValue) {
                  onChangeMethod(newValue);
                },
              ),
            )
          ],
        ),
      );
    }

    // Function to create button with on tap gesture
    GestureDetector buildAccountOption(BuildContext context, String title) {
      return GestureDetector(
        onTap: () async {
          if (title.toLowerCase() == "change password") {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple[300],
                    ),
                  ),
                );
              },
            );
            // Initialize current loggedIN user
            try {
              final user = _auth.getCurrentUser();
              await _auth.sendPasswordResetEmail(user!.email);
              // Close the loading spinner dialog
              Navigator.of(context).pop();
              // Display the success model
              _alert.successAlert(
                  context, "Please check your email for password reset");
            } catch (err) {
              // Close the loading spinner dialog
              Navigator.of(context).pop();
              // Displaying the error model
              _alert.errorAlert(
                  context, "Something went wrong, please try again later");
            }
          } else if (title.toLowerCase() == "team") {
            _alert.teamAlert(context);
          } else if (title.toLowerCase() == "terms of use") {
            _alert.settingsAlert(
                context, "Terms of Use", settingsData["Terms of Use"]!);
          } else if (title.toLowerCase() == "privacy policy") {
            _alert.settingsAlert(
                context, "Privacy Policy", settingsData["Privacy Policy"]!);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      );
    }

    return Theme(
      data: ThemeData(
        brightness:
            themeProvider.darkTheme ? Brightness.dark : Brightness.light,
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: themeProvider.darkTheme ? Colors.white : Colors.grey[50],
            // Set other properties as needed
          ),
        ),
        // Add other theme properties as needed
      ),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurple.shade300,
            onPressed: () async {
              UserModel? user =
                  await UserService(_auth.getCurrentUser()!.uid).getUserData();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerSupportChat(
                    userName: user!.name,
                    userEmail: user!.email,
                  ),
                ),
              );
            },
            child: const Icon(
              Icons.support_agent,
              size: 40,
            )),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Icon(Icons.person, color: Colors.deepPurple.shade300),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("Account",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade300))
                ],
              ),
              const Divider(
                height: 20,
                thickness: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              buildAccountOption(context, "Change Password"),
              buildAccountOption(context, "Team"),
              buildAccountOption(context, "Terms of Use"),
              buildAccountOption(context, "Privacy Policy"),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Icon(Icons.settings, color: Colors.deepPurple.shade300),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("Others",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade300))
                ],
              ),
              const Divider(
                height: 20,
                thickness: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              buildSettingOption(
                  "Theme Dark", themeProvider.darkTheme, onChangeDarkTheme),
              const SizedBox(
                height: 60,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade300,
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        _alert.showLogoutConfirmationDialog(context);
                      },
                      child: const Text(
                        "LOG OUT",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade300,
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        _alert.showDeleteAccountConfirmationDialog(context);
                      },
                      child: const Text(
                        "DELETE",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
