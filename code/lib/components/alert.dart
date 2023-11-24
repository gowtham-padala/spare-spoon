import 'package:code/controller/auth_service.dart';
import 'package:code/controller/recipe_service.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

/// A utility class for displaying custom modal dialogs using QuickAlert library.
/// This class provides methods to show error, warning, and success modals.
class Alert {
  final RecipeService _recipeService = RecipeService();
  final AuthService _authService = AuthService();

  /// Displays an error modal dialog with the given error message.
  void errorAlert(BuildContext context, String errMsg) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: "Error",
      text: errMsg,
      confirmBtnColor: Colors.deepPurple[300]!,
    );
  }

  /// Displays a warning modal dialog with the given warning message.
  void warningAlert(BuildContext context, String warningMsg) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: "Warning",
      text: warningMsg,
      confirmBtnColor: Colors.deepPurple[300]!,
    );
  }

  /// Displays a success modal dialog with the given success message.
  void successAlert(BuildContext context, String successMsg) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: "Success",
      text: successMsg,
      confirmBtnColor: Colors.deepPurple[300]!,
    );
  }

  Future<RecipeDialogResult?> saveRecipeAlert(BuildContext context) async {
    String recipeName = '';
    bool isFavorite = false;

    return showDialog<RecipeDialogResult>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
            ),
            child: const Text(
              "Enter Recipe Name",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 2.0,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  recipeName = value;
                },
                decoration: const InputDecoration(labelText: 'Recipe Name'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Mark as Favorite'),
                  Checkbox(
                    value: isFavorite,
                    onChanged: (value) {
                      isFavorite = value ?? false;
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                // await _recipeService.saveRecipe(_authService!.getCurrentUser(), recipe)
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Display information related to team in the card format
  /// @param {BuildContext} context - current context in the app
  void teamAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
            ),
            child: const Text(
              "Our Team",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 2.0,
              ),
            ),
          ),
          titlePadding: const EdgeInsets.all(0),
          content: SizedBox(
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildTeamMemberCard("Harsh Sharma", "201961844"),
                const SizedBox(height: 20),
                buildTeamMemberCard("Abhishek Gujjar", "202057931"),
                const SizedBox(height: 20),
                buildTeamMemberCard("Gowtham Padala", "201900149"),
                const SizedBox(height: 20),
                buildTeamMemberCard("Faiyez Noor", "201928975"),
              ],
            ),
          ),
          actions: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade300,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Display information related to terms of use and privacy policy for the SpareSpoon app
  /// @param {BuildContext} context - current context in the app
  /// @param {String} title - String title of the alert
  /// @param {List<String>} content - Body of the alert
  void settingsAlert(BuildContext context, String title, List<String> content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
            ),
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 2.0),
            ),
          ),
          titlePadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content.map((line) {
                if (line.startsWith(RegExp(r'\d+\.'))) {
                  // Lines starting with a number and a dot are considered headings
                  return Text(
                    line,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return Text(line);
                }
              }).toList(),
            ),
          ),
          actions: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade300,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 2.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showLogoutConfirmationDialog(BuildContext context) async {
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
        color: Colors.black,
      ),
      titleColor: Colors.black,
      textColor: Colors.black,
      onConfirmBtnTap: () async {
        await AuthService().signOut();
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Future<void> showDeleteAccountConfirmationDialog(BuildContext context) async {
    await QuickAlert.show(
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      context: context,
      type: QuickAlertType.confirm,
      text: 'Account Deletion Process is Irreversible',
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
        color: Colors.black,
      ),
      titleColor: Colors.black,
      textColor: Colors.black,
      onConfirmBtnTap: () async {
        await AuthService().deleteAccount();
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}

Widget buildTeamMemberCard(String name, String subtitle) {
  return Card(
    color: Colors.deepPurple.shade300,
    child: ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.school,
          color: Colors.black54,
          size: 30,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white, letterSpacing: 1.5),
      ),
    ),
  );
}
