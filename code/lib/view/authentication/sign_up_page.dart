import 'package:code/Components/alert.dart';
import 'package:code/components/text_form_field.dart';
import 'package:code/controller/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controller/user_service.dart';
import '../../model/user_model.dart';

class SignUp extends StatefulWidget {
  final void Function()? onPressed;
  const SignUp({super.key, required this.onPressed});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _isPasswordHidden = true;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _sex = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _dietaryPreferences = TextEditingController();
  final TextEditingController _allergies = TextEditingController();
  final TextEditingController _intolerances = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();
  final Alert _alert = Alert();

  createUserWithEmailAndPassword() async {
    try {
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });

      if (_password != _confirmPassword) {
        setState(() {
          isLoading = false;
        });
        _alert.warningAlert(
            context, "Password do not match, please provide matching password");
      }
      await _auth.registerWithEmailAndPassword(
        _email.text,
        _password.text,
      );

      final currentUser = _auth.getCurrentUser();
      if (currentUser != null) {
        final userModel = UserModel(
          id: currentUser.uid,
          name: _name.text,
          email: _email.text,
          sex: _sex.text,
          age: int.parse(_age.text),
          dietaryPreferences:
              _dietaryPreferences.text.split(',').map((e) => e.trim()).toList(),
          intolerances:
              _intolerances.text.split(',').map((e) => e.trim()).toList(),
          allergies: _allergies.text.split(',').map((e) => e.trim()).toList(),
        );

        // Creating an instance of UserController and calling createUser
        final userController = UserController(currentUser.uid);
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
        _alert.errorAlert(context, "The account already exists for that email");
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
                  Icon(
                    Icons.food_bank,
                    size: 100,
                    color: Colors.deepPurple[300],
                  ),
                  const SizedBox(height: 5),
                  // Welcome message
                  Text(
                    'SPARE SPOON',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Welcome message
                  Text(
                    'Let\'s create an account',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        // Email textFormField

                        child: SizedBox(
                          height: 45,
                          child: CustomTextField(
                            controller: _name,
                            hintText: 'Your name',
                            obscureText: false,
                            label: "Name",
                            iconButton: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.abc,
                                color: Colors.deepPurple[300],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: CustomTextField(
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: CustomTextField(
                            controller: _age,
                            hintText: 'Your age',
                            obscureText: false,
                            label: "Age",
                            iconButton: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.calendar_month,
                                color: Colors.deepPurple[300],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: CustomTextField(
                            controller: _sex,
                            hintText: 'Your sex',
                            obscureText: false,
                            label: "Sex",
                            iconButton: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.male,
                                color: Colors.deepPurple[300],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 45,
                    child: CustomTextField(
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
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 45,
                    child: CustomTextField(
                      controller: _confirmPassword,
                      hintText: 'Re-enter your Password',
                      obscureText: _isPasswordHidden,
                      label: "Confirm Password",
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
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 45,
                    child: CustomTextField(
                      controller: _dietaryPreferences,
                      hintText: 'Your dietary preference',
                      obscureText: false,
                      label: "Dietary Preferences",
                      iconButton: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.food_bank_outlined,
                          color: Colors.deepPurple[300],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 45,
                    child: CustomTextField(
                      controller: _allergies,
                      hintText: 'Your allergies',
                      obscureText: false,
                      label: "Allergies",
                      iconButton: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.no_food,
                          color: Colors.deepPurple[300],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 45,
                    child: CustomTextField(
                      controller: _intolerances,
                      hintText: 'Your intolerances',
                      obscureText: false,
                      label: "Intolerances",
                      iconButton: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.warning_amber_outlined,
                          color: Colors.deepPurple[300],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 15),
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
                            'Or',
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
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: OutlinedButton(
                      onPressed: widget.onPressed,
                      style: ButtonStyle(
                        side: MaterialStateProperty.resolveWith<BorderSide>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return const BorderSide(
                                  color: Colors.grey,
                                  width:
                                      2.0); // Border color and width when the button is disabled.
                            }
                            return BorderSide(
                                color: Colors.deepPurple.shade300,
                                width:
                                    2.0); // Border color and width for the default state.
                          },
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
