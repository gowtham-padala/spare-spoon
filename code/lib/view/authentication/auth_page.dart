import 'package:code/controller/auth_service.dart';
import 'package:code/controller/user_service.dart';
import 'package:code/model/user_model.dart';
import 'package:code/view/authentication/login_or_signup.dart';
import 'package:code/view/introduction/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

/// Widget class for the authentication page.
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data != null) {
            AuthService authService = AuthService();
            UserService userService =
                UserService(authService.getCurrentUser()!.uid);

            return FutureBuilder<UserModel?>(
              future: userService.getUserData(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (userSnapshot.hasError) {
                  return Center(child: Text('Error: ${userSnapshot.error}'));
                }

                UserModel? user = userSnapshot.data;

                if (user == null || user.isFirstTimeLogin) {
                  return const OnBoardingScreen();
                } else {
                  return const HomePage();
                }
              },
            );
          }
          // Handle the unauthenticated user or null data
          return const LoginAndSignUp();
        },
      ),
    );
  }
}
