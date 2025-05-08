import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:softrack/Authtentication/login.dart';
import 'package:softrack/JsonModels/note_model.dart';
import '../JsonModels/users.dart';
import '../supabase/supabase.dart';
/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class Notes extends StatefulWidget {
  final Users? userData;
  const Notes({super.key, this.userData});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late SupaBaseDatabaseHelper handler;
  late Future<List<NoteModel>> notes;
  final db = SupaBaseDatabaseHelper();

  final title = TextEditingController();
  final content = TextEditingController();
  final keyword = TextEditingController();

  @override
  void initState() {
    handler = SupaBaseDatabaseHelper();
    notes = handler.getNotesByUsername(widget.userData!.usrUserName); // Update to fetch notes for the current user
    super.initState();
  }

  Future<List<NoteModel>> getAllNotes() {
    return handler.getNotesByUsername(widget.userData!.usrUserName); // Update to fetch notes for the current user
  }

  // Search method here
  Future<List<NoteModel>> searchNote() {
    return handler.searchNotes(keyword.text,widget.userData!.usrUserName);
  }

  // Refresh method
  Future<void> _refresh() async {
    setState(() {
      notes = getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Profile(profile: widget.userData)),
                // ); // Removed 'const' here
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Field here
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(8)),
              child: TextFormField(
                controller: keyword,
                onChanged: (value) {
                  // When we type something in textfield
                  if (value.isNotEmpty) {
                    setState(() {
                      notes = searchNote();
                    });
                  } else {
                    setState(() {
                      notes = getAllNotes();
                    });
                  }
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    hintText: "Search"),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<NoteModel>>(
                future: notes,
                builder: (BuildContext context, AsyncSnapshot<List<NoteModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data"));
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    final items = snapshot.data ?? <NoteModel>[];
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        String formattedDate;
                        try {
                          formattedDate = DateFormat("yMd").format(DateTime.parse(items[index].createdAt));
                        } catch (e) {
                          formattedDate = "Invalid date";
                        }
                        return ListTile(
                          subtitle: Text(formattedDate),
                          title: Text(items[index].noteTitle),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Call the delete method in SupaBaseDatabaseHelper
                              db.deleteNote(items[index].noteId, widget.userData!.usrUserName).whenComplete(() {
                                // After successful delete, refresh notes
                                _refresh();
                              });
                            },
                          ),
                          onTap: () {
                            // When we click on note
                            setState(() {
                              title.text = items[index].noteTitle;
                              content.text = items[index].noteContent;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actions: [
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              // Update method
                                              db.updateNote(
                                                  title.text,
                                                  content.text,
                                                  items[index].noteId,
                                                  widget.userData!.usrUserName
                                              ).whenComplete(() {
                                                // After update, note will refresh
                                                _refresh();
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: const Text("Update"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                        ],
                                      ),
                                    ],
                                    title: const Text("Update note"),
                                    content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Two text fields
                                          TextFormField(
                                            controller: title,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Title is required";
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              label: Text("Title"),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: content,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Content is required";
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              label: Text("Content"),
                                            ),
                                          ),
                                        ]),
                                  );
                                });
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        )
    );
  }
}
