import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Widget for the second page of the introduction.
class IntroPage2 extends StatefulWidget {
  // Variable to store the name of the user.
  final String name;
  // Variable to store the age of the user.
  final int age;
  // Variable to store the gender of the user
  final String sex;
  final void Function(String name, int age, String sex) onNext;

  const IntroPage2(
      {Key? key,
      required this.name,
      required this.age,
      required this.sex,
      required this.onNext})
      : super(key: key);

  @override
  _IntroPage2State createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
  // Text editing controller for the name field.
  final TextEditingController _nameController = TextEditingController();
  // Initial value for the age field.
  int _selectedAge = 0;
  // Initial value for gender field.
  String _selectedSex = 'Male';

  @override
  void initState() {
    _selectedAge = (widget.age == 0) ? 0 : widget.age;
    _selectedSex = (widget.sex == "") ? "Male" : widget.sex;
    _nameController.text = (widget.name.trim() == "") ? "" : widget.name;
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
            Lottie.asset('assets/intro_page_two.json'),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  color: Colors.deepPurple.shade300,
                  width: 100,
                  height: 40,
                  child: const Center(
                    child: Text('AGE',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 40),
                DropdownButton<int>(
                  value: _selectedAge,
                  onChanged: (value) {
                    setState(() {
                      _selectedAge = value!;
                    });
                  },
                  items: List.generate(101, (index) => index)
                      .map((age) => DropdownMenuItem<int>(
                            value: age,
                            child: Text('$age'),
                          ))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                    color: Colors.deepPurple.shade300,
                    width: 100,
                    height: 40,
                    child: const Center(
                        child: Text('GENDER',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)))),
                const SizedBox(width: 40),
                DropdownButton<String>(
                  value: _selectedSex,
                  onChanged: (value) {
                    setState(() {
                      _selectedSex = value!;
                    });
                  },
                  items: ['Male', 'Female', 'Others']
                      .map((sex) => DropdownMenuItem<String>(
                            value: sex,
                            child: Text(sex),
                          ))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onNext(_nameController.text, _selectedAge, _selectedSex);
              },
              child: const Text('Save and Next'),
            ),
          ],
        ),
      ),
    );
  }
}
