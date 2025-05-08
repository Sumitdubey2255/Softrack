import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:softrack/JsonModels/note_model.dart';
import 'package:softrack/Views/create_note.dart';
import 'package:softrack/constants/app_images.dart';
import '../../../JsonModels/users.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_icons.dart';
import '../../../supabase/supabase.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class CreateNotificationPage extends StatefulWidget {
  final Users? userData;
  const CreateNotificationPage({super.key, this.userData});

  @override
  State<CreateNotificationPage> createState() => _CreateNotificationPageState();
}

class _CreateNotificationPageState extends State<CreateNotificationPage> {
  late Future<List<NoteModel>> notes;
  final db = SupaBaseDatabaseHelper();
  late SupaBaseDatabaseHelper handler;

  final title = TextEditingController();
  final content = TextEditingController();
  final keyword = TextEditingController();

  @override
  void initState() {
    handler = SupaBaseDatabaseHelper();
    notes = handler.getNotesByUsername(widget.userData!.usrUserName); // Fetch notes for the current user
    super.initState();
  }

  Future<List<NoteModel>> getAllNotes() {
    return handler.getNotesByUsername(widget.userData!.usrUserName); // Fetch notes for the current user
  }

  Future<List<NoteModel>> searchNote() {
    return handler.searchNotes(keyword.text, widget.userData!.usrUserName);
  }

  Future<void> _refresh() async {
    setState(() {
      notes = getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text('Notifications'),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      floatingActionButton: Container(
        width: 50.0,  // Custom width
        height: 50.0, // Custom height
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Makes the button circular
          gradient: const LinearGradient( // Adds a gradient background
            colors: [Colors.blue, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [ // Adds a shadow effect
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateNote(username: widget.userData!.usrUserName, userType: widget.userData!.usrActive,)),
            ).then((value) {
              if (value) {
                _refresh();
              }
            });
          },
          heroTag: null,
          elevation: 0, // Set elevation to 0 because we have a custom shadow
          backgroundColor: Colors.transparent, // Set to transparent to see the gradient
          child: const Icon(Icons.add, size: 36.0, color: Colors.white,), // Custom icon size
        ),
      ),
      body: Column(
        children: [
          _SearchPageHeader(
            searchController: keyword,
            onSearchChanged: (value) {
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
                        formattedDate = DateFormat("dd/MM/yyyy").format(DateTime.parse(items[index].createdAt));
                      } catch (e) {
                        formattedDate = "Invalid date";
                      }
                      return NotificationTile(
                        imageLink: AppImages.loginLogo,
                        title: items[index].noteTitle,
                        subtitle: items[index].noteContent,
                        time: formattedDate,
                        user:items[index].to,
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Delete Confirmation"),
                                content: const Text("Are you sure you want to delete this message?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      db.deleteNote(items[index].noteId, widget.userData!.usrUserName).whenComplete(() {
                                        _refresh(); // Refresh notes after deletion
                                      });
                                      Navigator.of(context).pop(); // Close the dialog after deletion
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
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
                                        const SizedBox(height: 10,),
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
      ),
    );
  }
}

class _SearchPageHeader extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String>? onSearchChanged;

  const _SearchPageHeader({
    required this.searchController,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Form(
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(AppDefaults.padding),
                        child: SvgPicture.asset(
                          AppIcons.search,
                          color: AppColors.primary,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(),
                      contentPadding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    textInputAction: TextInputAction.search,
                    autofocus: true,
                    onChanged: onSearchChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String? imageLink;
  final String title;
  final String subtitle;
  final String time;
  final String user;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationTile({
    super.key,
    this.imageLink,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.onTap,
    required this.onDelete,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: imageLink != null
                  ? AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.asset(imageLink!, fit: BoxFit.cover),
              )
                  : null,
              title: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis, // Handle overflow
                ),
                maxLines: 1, // Ensure title fits in one line
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.message, color: Colors.teal, size: 14),
                      const SizedBox(width: 5.0),
                      Flexible(
                        child: Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis, // Handle overflow
                          maxLines: 1, // Limit to 1 line
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.date_range_sharp, color: Colors.teal, size: 14),
                      const SizedBox(width: 5.0),
                      Text(time, style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: 16.0),
                      const Text("To: ", style: TextStyle(fontWeight: FontWeight.bold), ),
                      Flexible( // Ensure user text fits within the available space
                        child: Text(
                          user,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis, // Handle overflow
                          maxLines: 1, // Limit to 1 line
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDelete,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 86),
              child: Divider(thickness: 0.1),
            ),
          ],
        ),
      ),
    );
  }
}
