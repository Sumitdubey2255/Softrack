import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../JsonModels/create_comp.dart';
import '../JsonModels/users.dart';
import '../supabase/supabase.dart';
import 'dialogs/components/comp_KeyPage.dart';
import 'dialogs/login_page.dart';
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
  late Future<List<CreateComp>> notes;
  final db = SupaBaseDatabaseHelper();

  final title = TextEditingController();
  final content = TextEditingController();
  final keyword = TextEditingController();

  @override
  void initState() {
    handler = SupaBaseDatabaseHelper();
    notes = handler.getCompKeyByUsername(widget.userData!.usrUserName, widget.userData!.usrActive); // Fetch notes for the current user
    super.initState();
  }

  Future<List<CreateComp>> getAllCompKey() {
    return handler.getCompKeyByUsername(widget.userData!.usrUserName, widget.userData!.usrActive); // Fetch notes for the current user
  }

  Future<List<CreateComp>> searchCompKey() {
    return handler.searchCompKey(keyword.text, widget.userData!.usrUserName, widget.userData!.usrActive);
  }

  Future<void> _refresh() async {
    setState(() {
      notes = getAllCompKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Company Key"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Profile(profile: widget.userData)),
              // );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CompKeypage(userData: widget.userData)),
          ).then((value) {
            if (value) {
              _refresh();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: keyword,
              onChanged: (value) {
                setState(() {
                  notes = value.isNotEmpty ? searchCompKey() : getAllCompKey();
                });
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.search),
                hintText: "Search",
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CreateComp>>(
              future: notes,
              builder: (BuildContext context, AsyncSnapshot<List<CreateComp>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text("No data"));
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  final items = snapshot.data ?? <CreateComp>[];
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      String formattedDate;
                      try {
                        formattedDate = DateFormat("dd/MM/yyyy")
                            .format(DateTime.parse(item.createdAt));
                      } catch (e) {
                        formattedDate = "Invalid date";
                      }
                      return CompKeyCard(
                        customerName: item.usrName,
                        shopName: item.usrShopName,
                        formattedDate: formattedDate,
                        onEdit: () {
                          setState(() {
                            title.text = item.usrName;
                            content.text = item.usrShopName;
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
                                          db.updateNote(
                                            title.text,
                                            content.text,
                                            item.usrId,
                                            widget.userData!.usrUserName,
                                          ).whenComplete(() {
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
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        onDelete: () {
                          db.deleteNote(item.usrId, widget.userData!.usrUserName).whenComplete(() {
                            _refresh();
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

class CompKeyCard extends StatelessWidget {
  final String customerName;
  final String shopName;
  final String formattedDate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CompKeyCard({super.key, 
    required this.customerName,
    required this.shopName,
    required this.formattedDate,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 10.0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Transform.scale(
                        scale: 0.8,
                        child: Image.asset(
                          'images/typical_desktop.png',
                          fit: BoxFit.cover,
                          width: 65,
                          height: 65,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 26.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Shop: $shopName',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 3.0),
                        Row(
                          children: [
                            const Icon(Icons.date_range_sharp, color: Colors.teal, size: 14),
                            const SizedBox(width: 5.0),
                            Text(formattedDate, style: const TextStyle(fontSize: 12)),
                            const SizedBox(width: 16.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconInfo(icon: Icons.call, label: 'Call'),
                  IconInfo(icon: Icons.mail, label: 'Email'),
                  IconInfo(icon: Icons.share, label: 'Share'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class IconInfo extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconInfo({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.teal.withOpacity(0.1),
          ),
          padding: const EdgeInsets.all(5.0),
          child: Icon(icon, color: Colors.teal),
        ),
        const SizedBox(height: 4.0),
        Text(label, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}

class BoxIcon extends StatelessWidget {
  final IconData icons;

  const BoxIcon({super.key, required this.icons});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent.withOpacity(0.1),
      ),
      padding: const EdgeInsets.all(3.0),
      child: Icon(icons, color: Colors.redAccent),
    );
  }
}