import 'package:flutter/material.dart';
import 'package:noter_plus/utils/AddSpace.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        title: const Text('Options'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(bottom: 15, top: 10, left: 7, right: 7),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      const Text(
                        'Mode: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Exo2',
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        isSwitched ? 'Dark' : 'Light',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Exo2',
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                AddVertSpace(4),
                Switch(
                  activeColor: Colors.black87,
                  value: isSwitched,
                  onChanged: (bool switched) {
                    setState(() {
                      isSwitched = switched;
                    });
                  },
                  activeThumbImage: const AssetImage('images/dark.png'),
                  inactiveThumbImage: const AssetImage('images/light.png'),
                ),
                // MaterialButton(
                //   onPressed: () {
                //     Get.changeThemeMode(
                //         Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                //   },
                //   child: const Text("Switch Theme"),
                // ),
                AddVertSpace(10),
                const Divider(
                  color: Color.fromARGB(22, 0, 0, 0),
                  height: 1,
                  indent: 28,
                  endIndent: 28,
                ),
                AddVertSpace(10),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Theme',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Exo2',
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
