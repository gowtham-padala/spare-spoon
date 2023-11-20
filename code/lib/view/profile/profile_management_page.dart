// Import necessary packages and files
import 'package:code/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/alert.dart';
import '../../controller/user_service.dart';
import '../../model/user_model.dart';

// Widget for managing user profile information.
class ProfileManagementPage extends StatefulWidget {
  final String userId;

  // Constructor with named parameter and key.
  const ProfileManagementPage({required this.userId, Key? key})
      : super(key: key);

  @override
  State<ProfileManagementPage> createState() => _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementPage> {
  // User data model initialized with default values.
  UserModel userData = UserModel(
      id: "",
      name: "",
      email: "",
      sex: "",
      age: 0,
      dietaryPreferences: [],
      intolerances: [],
      allergies: []);

  // Controller for handling user-related operations.
  late UserController userController;

  // Form key for validating and managing the form state.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for managing text input fields.
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController dietaryPreferencesController = TextEditingController();
  TextEditingController intolerancesController = TextEditingController();
  TextEditingController allergiesController = TextEditingController();

  // Alert component for displaying notifications.
  final Alert _alert = Alert();

  @override
  void initState() {
    super.initState();
    // Initialize the user controller and fetch user data.
    userController = UserController(widget.userId);
    _fetchUserData();
  }

  // Asynchronously fetch user data and update the state.
  Future<void> _fetchUserData() async {
    UserModel? user = await userController.getUserData();

    if (user != null) {
      // Update the state with the fetched user data.
      setState(() {
        userData = user;
        nameController.text = userData.name;
        ageController.text = userData.age.toString();
        sexController.text = userData.sex;
        dietaryPreferencesController.text =
            userData.dietaryPreferences.join(', ');
        intolerancesController.text = userData.intolerances.join(', ');
        allergiesController.text = userData.allergies.join(', ');
      });
    } else {
      // Display a warning alert if no user data exists.
      if (mounted) {
        _alert.warningAlert(
          context,
          'No user data exists.',
        );
      }
    }
  }

  // Asynchronously update user data based on form input.
  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create a new UserModel with updated data.
        UserModel updatedUserData = UserModel(
          id: userData.id,
          name: nameController.text,
          email: userData.email,
          sex: sexController.text,
          age: int.parse(ageController.text),
          dietaryPreferences: dietaryPreferencesController.text.split(', '),
          intolerances: intolerancesController.text.split(', '),
          allergies: allergiesController.text.split(', '),
        );

        // Update user data and display a success alert.
        await userController.updateUserData(updatedUserData);

        setState(() {
          userData = updatedUserData;
          _alert.successAlert(
            context,
            'Profile Updated Successfully',
          );
        });
      } catch (e) {
        // Display a warning alert if age input is invalid.
        if (mounted) {
          _alert.warningAlert(
            context,
            'Please enter a valid age',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider using Provider
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Theme(
        data: ThemeData(
          brightness:
              themeProvider.darkTheme ? Brightness.dark : Brightness.light,
          // Add other theme properties as needed
        ),
        child: Scaffold(
          body: SingleChildScrollView(
            child: _buildProfileContent(),
          ),
        ));
  }

  // Widget for building the profile content form.
  Widget _buildProfileContent() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Build editable profile fields using shared method.
            _buildEditableProfileField(
              "Name:",
              nameController,
              Icons.person,
            ),
            _buildEditableProfileField(
              "Age:",
              ageController,
              Icons.calendar_today,
            ),
            _buildEditableProfileField(
              "Sex:",
              sexController,
              Icons.male,
            ),
            _buildEditableProfileField(
              "Dietary Preferences:",
              dietaryPreferencesController,
              Icons.food_bank_outlined,
            ),
            _buildEditableProfileField(
              "Intolerances:",
              intolerancesController,
              Icons.warning_amber_outlined,
            ),
            _buildEditableProfileField(
              "Allergies:",
              allergiesController,
              Icons.no_food,
            ),
            // Button to trigger the update of user information.
            ElevatedButton(
              onPressed: _updateUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[300],
              ),
              child: const Text(
                "Update Information",
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for building an editable profile field with an icon.
  Widget _buildEditableProfileField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label for the input field.
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.deepPurple.shade300,
          ),
        ),
        const SizedBox(height: 5),
        // Text input field with validation and suffix icon.
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: '',
            errorStyle: const TextStyle(height: 0),
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(
                icon,
                color: Colors.deepPurple[300],
              ),
            ),
          ),
          validator: (value) {
            // Validate input based on label and field type.
            if (label != "Dietary Preferences:" &&
                label != "Intolerances:" &&
                label != "Allergies:") {
              if (value == null || value.isEmpty) {
                return '$label cannot be empty';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 17),
      ],
    );
  }
}
