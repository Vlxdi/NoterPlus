import 'dart:ui';

import 'package:flutter/material.dart';

import 'Utils/AddSpace.dart';

class Go extends StatefulWidget {
  const Go({super.key});

  @override
  State<Go> createState() => _GoState();
}

class _GoState extends State<Go> {
  bool isSwitched = false;
  bool? isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        title: const Text('Discover'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            padding: const EdgeInsets.only(right: 10),
            onPressed: () {
              debugPrint('Info pressed');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'images/earthnz.png',
              fit: BoxFit.cover,
            ),
            AddVertSpace(20),
            Container(
              padding:
                  const EdgeInsets.only(bottom: 10, top: 10, left: 5, right: 5),
              decoration: BoxDecoration(
                color: isSwitched
                    ? Colors.green
                    : const Color.fromARGB(255, 0, 89, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              width: 200,
              child: const Center(
                child: SizedBox(
                  child: Text(
                    'New Zealand',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            AddVertSpace(30),
            ElevatedButton(
              onPressed: () {
                debugPrint('Elevated Button');
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
              ),
              child: const Text('Button 1'),
            ),
            AddVertSpace(10),
            OutlinedButton(
              onPressed: () {
                debugPrint('Outlined Button');
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
              ),
              child: const Text('Button 2'),
            ),
            AddVertSpace(10),
            TextButton(
              onPressed: () {
                debugPrint('Text Button');
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
              ),
              child: const Text('Button 3'),
            ),
            Switch(
                value: isSwitched,
                onChanged: (bool switched) {
                  setState(() {
                    isSwitched = switched;
                  });
                }),
            Checkbox(
                value: isChecked,
                onChanged: (bool? checked) {
                  setState(() {
                    isChecked = checked;
                    debugPrint('Checked or unchecked');
                  });
                }),
            AddVertSpace(200),
            SizedBox(
              width: double.maxFinite,
              child: Image.network(
                'https://media.discordapp.net/attachments/938093372676112475/1089569636682584154/SPOILER_latest.png?width=478&height=637',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
