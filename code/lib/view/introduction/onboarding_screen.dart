import 'package:code/controller/auth_service.dart';
import 'package:code/controller/user_service.dart';
import 'package:code/model/user_model.dart';
import 'package:code/view/authentication/auth_page.dart';
import 'package:code/view/introduction/intro_page_1.dart';
import 'package:code/view/introduction/intro_page_2.dart';
import 'package:code/view/introduction/intro_page_3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  final AuthService _auth = AuthService();

  String name = '';
  int age = 0;
  String sex = '';
  List<String> dietaryPreferences = [];
  List<String> allergies = [];
  List<String> intolerances = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              const IntroPage1(),
              IntroPage2(
                name: name,
                age: age,
                sex: sex,
                onNext: (n, a, s) {
                  setState(() {
                    name = n;
                    age = a;
                    sex = s;
                  });
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
              ),
              IntroPage3(
                  dietaryPreferences: dietaryPreferences,
                  intolerances: intolerances,
                  allergies: allergies,
                  onFinish: (dp, a, i) async {
                    setState(() {
                      dietaryPreferences = dp;
                      allergies = a;
                      intolerances = i;
                    });

                    final currentUser = _auth.getCurrentUser();
                    if (currentUser != null) {
                      final userModel = UserModel(
                          id: currentUser.uid,
                          name: name,
                          email: currentUser.email!,
                          sex: sex,
                          age: age,
                          dietaryPreferences: dietaryPreferences,
                          intolerances: intolerances,
                          allergies: allergies,
                          isFirstTimeLogin: false);

                      // Creating an instance of UserController and calling createUser
                      final userController = UserService(currentUser.uid);
                      await userController.createUser(userModel);

                      // Navigate to the home page once the onboarding is complete
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const AuthPage()),
                      );
                    }
                  }),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SmoothPageIndicator(controller: _controller, count: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
