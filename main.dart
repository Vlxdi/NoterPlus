import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noter_plus/home_page.dart';
import 'package:noter_plus/notes_page.dart';
import 'package:noter_plus/profile.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:hidden_drawer_menu/model/item_hidden_menu.dart';
import 'package:hidden_drawer_menu/model/screen_hidden_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';

import 'Menu/help.dart';
import 'Menu/options.dart';

final Uri _url = Uri.parse('https://flutter.dev');
const customSwatch = MaterialColor(0xFF0059FF, <int, Color>{
  50: Color(0xFFE3F2FD),
  100: Color(0xFFBBDEFB),
  200: Color(0xFF90CAF9),
  300: Color(0xFF64B5F6),
  400: Color(0xFF42A5F5),
  500: Color(0xFF2196F3),
  600: Color(0xFF1E88E5),
  700: Color(0xFF1976D2),
  800: Color(0xFF1565C0),
  900: Color(0xFF0D47A1),
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: customSwatch,
      ),
      home: const HiddenDrawer(),
      routes: {
        // add routes to each page
        '/options': (context) => const OptionsPage(),
        '/help': (context) => const HelpPage(),
      },
    );
  }
}

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  final menuTextStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  final selTextStyle = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18);

  @override
  void initState() {
    super.initState();
    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Home',
          baseStyle: menuTextStyle,
          selectedStyle: selTextStyle,
          colorLineSelected: customSwatch,
        ),
        const HomePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Notes',
          baseStyle: menuTextStyle,
          selectedStyle: selTextStyle,
          colorLineSelected: customSwatch,
        ),
        const Notes(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Profile',
          baseStyle: menuTextStyle,
          selectedStyle: selTextStyle,
          colorLineSelected: customSwatch,
        ),
        const Profile(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      screens: _pages,
      backgroundColorMenu: const Color.fromARGB(255, 97, 122, 155),
      initPositionSelected: 0,
      slidePercent: 70,
      curveAnimation: Curves.fastEaseInToSlowEaseOut, //decelerate
      contentCornerRadius: 10.0,
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(216, 22, 22, 22).withOpacity(0.5),
          spreadRadius: 30,
          blurRadius: 20,
          offset: const Offset(-15, 30),
        ),
      ],
      // // backgroundMenu: const DecorationImage(
      // //   image: AssetImage('images/drawerbackground.jpg'),
      // //   fit: BoxFit.cover,
      // // ),
      isTitleCentered: true,
      isDraggable: true,
      actionsAppBar: [
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              padding: const EdgeInsets.only(right: 10),
              onPressed: () async {
                final selectedValue = await showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    MediaQuery.of(context).size.width,
                    kToolbarHeight,
                    0,
                    0,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.zero, // Leave top right corner as it is
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                  items: [
                    const PopupMenuItem<String>(
                      value: 'options',
                      child: Text('Options'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'help',
                      child: Text('Help'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'contact',
                      child: Text('Contact'),
                    ),
                  ],
                );
                final navigator = Navigator.of(context);
                switch (selectedValue) {
                  case 'options':
                    navigator.pushNamed('/options');
                    break;
                  case 'help':
                    navigator.pushNamed('/help');
                    break;
                  case 'contact':
                    launchUrl(_url);
                    break;
                }
              },
              icon: const Icon(Icons.more_vert_rounded),
            );
          },
        ),
      ],
    );
  }
}
