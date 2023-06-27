import 'package:flutter/material.dart';
import 'package:noter_plus/utils/AddSpace.dart';

const itemCount = 3;

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      body: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  title: Text('Profile ${(index + 1)}'),
                  contentPadding: const EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  selectedColor: Colors.grey,
                  tileColor: Colors.white,
                  // dense: true,
                  subtitle: const Text('Profile information/About/Bio'),
                  leading: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Text('Add profile picture'),
                                  ),
                                ],
                              ),
                              // content: const Image(
                              //     image: AssetImage('images/profilepic.png')),
                              content: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.image_rounded,
                                  size: 50,
                                  color: Colors
                                      .white, // Optionally, you can set a different color for the icon
                                ),
                              ),
                              actions: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Add',
                                          style: TextStyle(fontSize: 16),
                                        )),
                                  ),
                                )
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.person),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text('Switch profile?'),
                                AddVertSpace(28),
                                const Icon(
                                  Icons.swap_horiz_rounded,
                                  size: 50,
                                  color: Color.fromARGB(255, 0, 89, 255),
                                )
                              ],
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text('NO'),
                                  ),
                                  AddHorizSpace(15),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('YES'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ).then((value) {
                        if (value == true) {
                          debugPrint('Switching to profile ${(index + 1)}');
                          // Add your code to switch to the selected profile here
                        }
                      });
                    },
                  ),
                  onTap: () {
                    debugPrint('Profile ${(index + 1)} selected');
                  }),
            );
          }),
    );
  }
}
