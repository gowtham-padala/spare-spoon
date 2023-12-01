import 'package:code/Components/alert.dart';
import 'package:code/components/square_tile.dart';
import 'package:code/components/text_form_field.dart';
import 'package:code/controller/auth_service.dart';
import 'package:code/controller/user_service.dart';
import 'package:code/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Widget class for the login page.
class SignUp extends StatefulWidget {
  final void Function()? onPressed;
  const SignUp({super.key, required this.onPressed});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  // Variable to store the loading state of the page
  bool isLoading = false;
  // Variable to store the password visibility state
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  // Text editing controllers for the email field
  final TextEditingController _email = TextEditingController();
  // Text editing controllers for the password field
  final TextEditingController _password = TextEditingController();
  // Text editing controllers for the confirm password field
  final TextEditingController _confirmPassword = TextEditingController();
  // Scaffold key to show snack bar
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Authentication service instance
  final AuthService _auth = AuthService();
  // Alert class instance
  final Alert _alert = Alert();

  createUserWithEmailAndPassword() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    if (_password.text.trim() != _confirmPassword.text.trim()) {
      setState(() {
        isLoading = false;
      });
      _alert.warningAlert(
          context, "Password do not match, please provide matching password");
    } else {
      try {
        await _auth.registerWithEmailAndPassword(
          _email.text,
          _password.text,
        );

        final currentUser = _auth.getCurrentUser();
        if (currentUser != null) {
          final userModel = UserModel(
            id: currentUser.uid,
            name: "",
            email: _email.text,
            sex: "",
            age: 0,
            isFirstTimeLogin: true,
            dietaryPreferences: [],
            intolerances: [],
            allergies: [],
          );

          // Creating an instance of UserController and calling createUser
          final userController = UserService(currentUser.uid);
          await userController.createUser(userModel);
        }
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'weak-password') {
          _alert.errorAlert(context, "The password provided is too weak");
        } else if (e.code == 'email-already-in-use') {
          _alert.errorAlert(
              context, "The account already exists for that email");
        } else if (e.code.toLowerCase() == 'invalid-email') {
          if (context.mounted) {
            _alert.errorAlert(context, "Please provide a valid email address.");
          }
        } else {
          _alert.errorAlert(
              context, "Something went wrong, please try again later");
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Icon(
                    Icons.food_bank,
                    size: 100,
                    color: Colors.deepPurple[300],
                  ),
                  const SizedBox(height: 30),
                  // Welcome message
                  Text(
                    'SPARE SPOON',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Welcome message
                  Text(
                    'Let\'s create an account',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    controller: _email,
                    hintText: 'hello@company.com',
                    obscureText: false,
                    label: "Email",
                    iconButton: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.email,
                        color: Colors.deepPurple[300],
                      ),
                    ),
                  ),
                  // Size box with
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _password,
                    hintText: 'Your password',
                    obscureText: _isPasswordHidden,
                    label: "Password",
                    iconButton: IconButton(
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.deepPurple.shade300,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                  ),
                  // Size box with
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _confirmPassword,
                    hintText: 'Re-enter your Password',
                    obscureText: _isConfirmPasswordHidden,
                    label: "Confirm Password",
                    iconButton: IconButton(
                      icon: Icon(
                        _isConfirmPasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.deepPurple.shade300,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          createUserWithEmailAndPassword();
                        }
                      },
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.black,
                            ))
                          : const Text('Sign Up'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.deepPurple[300],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or Continue with',
                            style: TextStyle(color: Colors.deepPurple[300]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.deepPurple[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Google sign in button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google button
                      SquareTile(
                          onTap: () => AuthService().signInWithGoogle(),
                          imagePath: 'assets/google.png'),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Already have an account? Login now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onPressed,
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
