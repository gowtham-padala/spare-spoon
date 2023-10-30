import 'package:code/model/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'model/recipe_model_adapter_hive.dart';
import 'utils/firebase_options.dart';
import 'view/auth_page.dart';
import '';

void main() async {

  await Hive.initFlutter();
  Hive.registerAdapter(RecipeModelHiveAdapter());
  await Hive.openBox<RecipeModel>('recipes');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //primarySwatch: Colors.blueGrey,
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
        //scaffoldBackgroundColor: const Color.fromARGB(255, 116, 143, 155),
      ),
      home: const AuthPage(),
    );
  }
}
