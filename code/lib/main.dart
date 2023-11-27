import 'package:code/utils/theme_provider.dart';
import 'package:code/view/authentication/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Import the ThemeProvider class

import 'utils/firebase_options.dart';

MaterialColor customDeepPurple = const MaterialColor(
  0xFF9575CD, // Replace this with your desired primary color value
  <int, Color>{
    50: Color(0xFFEDE7F6),
    100: Color(0xFFD1C4E9),
    200: Color(0xFFB39DDB),
    300: Color(0xFF9575CD),
    400: Color(0xFF7E57C2),
    500: Color(0xFF673AB7),
    600: Color(0xFF5E35B1),
    700: Color(0xFF512DA8),
    800: Color(0xFF4527A0),
    900: Color(0xFF311B92),
  },
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(), // Create a ThemeProvider instance
      child: const SpareSpoonApp(),
    ),
  );
}

class SpareSpoonApp extends StatelessWidget {
  const SpareSpoonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: customDeepPurple,
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
      ),
      home: const AuthPage(),
    );
  }
}
