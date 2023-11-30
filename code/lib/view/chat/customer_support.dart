import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';

class CustomerSupportChat extends StatelessWidget {
  final String userName;
  final String userEmail;

  const CustomerSupportChat({
    required this.userName,
    required this.userEmail,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: const Text('Spare Spoon Chat Support'),
        backgroundColor: Colors.deepPurple.shade300,
        elevation: 0,
      ),
      body: Tawk(
        directChatLink:
            'https://tawk.to/chat/6568cf68ff45ca7d47855c03/1hggmkc93',
        visitor: TawkVisitor(
          name: userName,
          email: userEmail,
        ),
        placeholder: const Center(
          child:
              CircularProgressIndicator(), // Use CircularProgressIndicator for loading
        ),
      ),
    );
  }
}
