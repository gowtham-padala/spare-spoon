import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({Key? key}) : super(key: key);

  @override
  _IntroPage1State createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Icon(
            Icons.food_bank_outlined,
            size: 100,
            color: Colors.deepPurple[300],
          ),
          Text(
            'Welcome to Spare Spoon',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[300],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your Personal Recipe Assistant',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 32),
          Center(child: Lottie.asset('assets/intro_page_one.json')),
        ],
      ),
    );
  }
}
