import 'package:flutter/material.dart';

class RecipesDetailsPage extends StatelessWidget {
  final String name;
  final String description;

  const RecipesDetailsPage(
      {required this.name, required this.description, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Center(
          child: Text(
            'Recipe Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                //color: const Color.fromARGB(255, 114, 178, 172),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'How Do I Make It?',
                        style: TextStyle(
                          fontSize: 20, // Adjust the font size as desired
                          fontStyle: FontStyle.italic, // Set to italic
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                //color: const Color.fromARGB(255, 114, 178, 172),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Add more details about how to make the recipe
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class RecipesDetailsPage extends StatelessWidget {
//   final String name;
//   final String description;

//   const RecipesDetailsPage(
//       {required this.name, required this.description, Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[900],
//       appBar: AppBar(
//         backgroundColor: Colors.grey[850],
//         title: const Center(
//           child: Text(
//             'Recipe Details',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             const SizedBox(height: 20),
//             Card(
//               elevation: 5,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               color: const Color.fromARGB(255, 114, 178, 172),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               color: const Color.fromARGB(
//                   255, 114, 178, 172), // Set background color
//               child: const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   'How Do I Make It?',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Card(
//               elevation: 5,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               color: const Color.fromARGB(255, 114, 178, 172),
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     description,
//                     style: const TextStyle(
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // Add more details about how to make the recipe
//           ],
//         ),
//       ),
//     );
//   }
// }
