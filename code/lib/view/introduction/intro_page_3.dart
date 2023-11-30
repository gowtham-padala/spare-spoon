// In IntroPage3.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Widget for the third page of the introduction.
class IntroPage3 extends StatefulWidget {
  final void Function(List<String> dietaryPreferences, List<String> allergies,
      List<String> intolerances) onFinish;
  // Variable to store the dietary preferences of the user.
  final List<String> dietaryPreferences;
  // Variable to store the allergies of the user.
  final List<String> allergies;
  // Variable to store the intolerances of the user.
  final List<String> intolerances;

  const IntroPage3({
    Key? key,
    required this.onFinish,
    required this.dietaryPreferences,
    required this.allergies,
    required this.intolerances,
  }) : super(key: key);

  @override
  _IntroPage3State createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  // Text editing controller for the dietary preferences field.
  final TextEditingController _dietaryController = TextEditingController();
  // Text editing controller for the allergies field.
  final TextEditingController _allergiesController = TextEditingController();
  // Text editing controller for the intolerances field.
  final TextEditingController _intolerancesController = TextEditingController();

  @override
  void initState() {
    _dietaryController.text = (widget.dietaryPreferences.isEmpty)
        ? ""
        : widget.dietaryPreferences.join(', ');
    _allergiesController.text =
        (widget.allergies.isEmpty) ? "" : widget.allergies.join(', ');
    _intolerancesController.text =
        (widget.intolerances.isEmpty) ? "" : widget.intolerances.join(', ');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            Lottie.asset("assets/intro_page_three.json"),
            TextFormField(
              controller: _dietaryController,
              decoration:
                  const InputDecoration(labelText: 'Dietary Preferences'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _allergiesController,
              decoration: const InputDecoration(labelText: 'Allergies'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _intolerancesController,
              decoration: const InputDecoration(labelText: 'Intolerances'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onFinish(
                  _dietaryController.text
                      .split(',')
                      .map((e) => e.trim())
                      .toList(),
                  _allergiesController.text
                      .split(',')
                      .map((e) => e.trim())
                      .toList(),
                  _intolerancesController.text
                      .split(',')
                      .map((e) => e.trim())
                      .toList(),
                );
              },
              child: const Text('Save and Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
