import 'package:flutter/material.dart';
import 'package:noter_plus/main.dart';
import 'package:noter_plus/utils/AddSpace.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<String> notes = [];
  String? deletedNote;

  @override
  void dispose() {
    _noteController.dispose();
    _searchController.dispose(); // dispose the search controller
    super.dispose();
  }

  void _addNote() {
    String note = _noteController.text;
    setState(() {
      notes.add(note);
    });
    _noteController.clear();
    _firestore.collection('notes').add({'content': note});
  }

  void _deleteNote(int index) {
    String note = notes[index];
    setState(() {
      deletedNote = note; // Set the deleted note
      notes.removeAt(index);
    });
    _firestore
        .collection('notes')
        .where('content', isEqualTo: note)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  void _getNotes() {
    _firestore.collection('notes').get().then((snapshot) {
      setState(() {
        notes = snapshot.docs
            .map((doc) => doc.data()['content'])
            .toList()
            .cast<String>();
        notes.removeWhere(
            (note) => note == deletedNote); // Exclude the deleted note
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Color(0xFF0059FF),
            )),
            suffixIcon: Icon(Icons.search),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.grey,
            )),
          ),
          onChanged: (query) {
            setState(() {}); // rebuild the widget to update the notes list
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0, // remove the shadow
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 89, 255),
        child: const Icon(Icons.add),
        onPressed: () async {
          _noteController.clear();
          final result = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Add note'),
                    IconButton(
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2030))
                              .then((value) {
                            if (value != null) {
                              showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.notification_add_rounded,
                          color: Colors.grey,
                        ))
                  ],
                ),
                content: Flexible(
                  child: TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                        hintText: 'Type here...',
                        hintStyle: TextStyle(color: Colors.grey)),
                    onChanged: (String value) {},
                    maxLines: null,
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('CANCEL'),
                      ),
                      AddHorizSpace(30),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, _noteController.text);
                        },
                        child: const Text('ADD'),
                      ),
                    ],
                  )
                ],
              );
            },
          );
          if (result != null && result.isNotEmpty) {
            setState(() {
              _addNote();
            });
          }
        },
      ),
      body: ListView.builder(
        //ReorderableListView.builder
        padding: const EdgeInsets.all(10),
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          final query = _searchController.text.toLowerCase().trim();
          final note = notes[index].toLowerCase();
          if (query.isNotEmpty && !note.contains(query)) {
            return const SizedBox
                .shrink(); // hide the note if it doesn't match the search query
          }
          return Dismissible(
            key: Key(notes[index]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteNote(index);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Note deleted.'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    setState(() {
                      if (deletedNote != null) {
                        notes.insert(index, deletedNote!);
                        // Add code here to update the note in Firestore
                        _firestore
                            .collection('notes')
                            .add({'content': deletedNote}).then((docRef) {
                          String docId = docRef.id;
                          _firestore
                              .collection('notes')
                              .doc(docId)
                              .update({'content': deletedNote});
                        }).catchError((error) {
                          print('Failed to update note in Firestore: $error');
                        });
                      }
                    });
                  },
                ),
              ));
            },
            background: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              margin: const EdgeInsets.all(5),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(
                    10.0)), // Adjust the value as per your requirement
              ),
              elevation: 4,
              color: const Color.fromRGBO(252, 253, 255, 0.877),
              child: InkWell(
                child: ListTile(
                  title: Text(notes[index]),
                  leading: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.drag_handle)),
                  trailing: GestureDetector(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          String currentNote = notes[index];
                          String newNote = '';
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Edit'),
                                AddHorizSpace(45),
                                Flexible(
                                  flex: 1,
                                  child: IconButton(
                                    onPressed: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2030))
                                          .then((value) {
                                        if (value != null) {
                                          showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now());
                                        }
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.notification_add_rounded,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            title:
                                                const Text('Delete this note'),
                                            content: const Text(
                                                'Are you sure you want to delete this note?'),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _deleteNote(index);
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      //Navigator.of(context).pop();
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            content: SizedBox(
                              height: 50, // Adjust the height as needed
                              child: Column(
                                children: [
                                  Flexible(
                                    child: TextField(
                                      // controller: _noteController,

                                      onChanged: (value) {
                                        newNote = value;
                                      },
                                      decoration: const InputDecoration(
                                          hintText:
                                              'Type here...', //or notes[index];
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                      maxLines:
                                          null, // Allow the TextField to dynamically adjust its size
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Flexible(
                                    child: Wrap(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'CANCEL',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const VerticalDivider(
                                    width: 45,
                                    color: Colors.transparent,
                                  ),
                                  Wrap(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            notes[index] =
                                                newNote; // Update the note in the local list
                                          });

                                          // Update the note in Firestore
                                          _firestore
                                              .collection('notes')
                                              .where('content',
                                                  isEqualTo: currentNote)
                                              .get()
                                              .then((snapshot) {
                                            snapshot.docs.forEach((doc) {
                                              doc.reference
                                                  .update({'content': newNote});
                                            });
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'SAVE',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.edit, color: Colors.grey),
                  ),
                ),
              ),
            ),
          );
        },
        // onReorder: (int oldIndex, int newIndex) {
        //   setState(() {
        //     if (oldIndex < newIndex) {
        //       newIndex -= 1;
        //     }
        //     final String item = notes.removeAt(oldIndex);
        //     notes.insert(newIndex, item);
        //   });
        // }
      ),
    );
  }
}
