import 'package:code/components/alert.dart';
import 'package:code/components/square_tile.dart';
import 'package:code/components/text_form_field.dart';
import 'package:code/controller/auth_service.dart';
import 'package:code/view/authentication/forgot_passwor_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Widget class for the login page.
class LoginPage extends StatefulWidget {
  final void Function()? onPressed;
  const LoginPage({super.key, required this.onPressed});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPasswordHidden = true;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final Alert _alert = Alert();
  final AuthService _auth = AuthService();

  signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _auth.signInWithEmailAndPassword(
          _email.text.trim(), _password.text);
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        if (context.mounted) {
          _alert.errorAlert(
              context, "Invalid login credentials. Please try again.");
        }
      } else {
        if (context.mounted) {
          _alert.errorAlert(context, "Something went wrong. Please try again.");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  // Logo
                  Icon(
                    Icons.food_bank_outlined,
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
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Email textFormField
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

                  // Email textField
                  CustomTextField(
                    controller: _password,
                    hintText: 'Your password',
                    obscureText: isPasswordHidden,
                    label: "Password",
                    isPasswordHidden: isPasswordHidden,
                    iconButton: IconButton(
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.deepPurple[300],
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Forgot password link
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigate to forgot password page
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const ForgotPasswordPage();
                              return Container();
                            }));
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signInWithEmailAndPassword();
                        }
                      },
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.black,
                            ))
                          : const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 39),
                  // Or continue with text
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
                            'Or continue with',
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
                          onTap: () => _auth.signInWithGoogle(),
                          imagePath: 'assets/google.png'),
                    ],
                  ),
                  // Sign Up button
                  const SizedBox(height: 70),

                  // Not a member? Register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onPressed,
                        child: const Text(
                          'Register now',
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
