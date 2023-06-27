import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        title: const Text('Help'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        //   actions: [
        //   IconButton(
        //     icon: const Icon(Icons.info),
        //     padding: const EdgeInsets.only(right: 10),
        //     onPressed: () {
        //       debugPrint('Info pressed');
        //     },
        //   ),
        // ],
      ),
      body: const Center(
        child: Text(
          'Help yourself💀',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
