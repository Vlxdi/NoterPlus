import 'package:flutter/material.dart';
import 'package:noter_plus/go.dart';
import 'package:noter_plus/Utils/AddSpace.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/treebgalt.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientText(
                'Discover',
                style: const TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Teko',
                ),
                colors: const [Color.fromARGB(255, 0, 89, 255), Colors.white],
              ),
              AddVertSpace(50),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const Go();
                    }),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Share Notes'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 17.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
