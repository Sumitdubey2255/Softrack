import 'package:flutter/material.dart';
import 'package:softrack/JsonModels/note_model.dart';
import 'package:uuid/uuid.dart';
import '../supabase/supabase.dart';
/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class CreateNote extends StatefulWidget {
  final String username;
  final String userType;
  const CreateNote({super.key, required this.username, required this.userType});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final title = TextEditingController();
  final content = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? _selectedUser = "All";

  final db = SupaBaseDatabaseHelper();
  final uuid = const Uuid();
  bool _isFormValid = false;
  List<String> _usernames = ['All'];

  final List<String> predefinedMessages = [
    "Meeting at 3 PM tomorrow",
    "Please review the attached document",
    "Reminder: Project deadline next week",
  ];

  void _addPredefinedMessage(String message) {
    content.text = message;
    _updateFormValidity();
  }

  String? dropdownValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a value';
    }
    return null;
  }

  void _updateFormValidity() {
    final isValid = formKey.currentState?.validate() ?? false;
    final hasSelectedUser = _selectedUser != null && _selectedUser!.isNotEmpty;
    setState(() {
      _isFormValid = isValid && hasSelectedUser;
    });
  }

  Future<void> _fetchUsernames() async {
    final usernames = await db.getUsernames(widget.username, widget.userType);
    setState(() {
      _usernames = ['All'] + usernames.map((user) => user.usrName).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUsernames();
    _updateFormValidity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Notification"),
        actions: [
          IconButton(
            onPressed: () {
              if (_isFormValid) {
                db.createNote(NoteModel(
                  noteId: uuid.v4(),
                  noteTitle: title.text,
                  noteContent: content.text,
                  createdAt: DateTime.now().toIso8601String(),
                  username: widget.username,
                  to: _selectedUser!,
                )).whenComplete(() {
                  Navigator.of(context).pop(true);
                });
              }
            },
            icon: Icon(
              Icons.check,
              color: _isFormValid ? Colors.green : Colors.red,
            ),
          )
        ],
      ),
      body: SingleChildScrollView( // Added SingleChildScrollView here
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: title,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Title is required";
                    }
                    return null;
                  },
                  onChanged: (_) => _updateFormValidity(),
                  decoration: const InputDecoration(
                    label: Text("Title"),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: content,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Message is required";
                    }
                    return null;
                  },
                  onChanged: (_) => _updateFormValidity(),
                  decoration: const InputDecoration(
                    label: Text("Message"),
                  ),
                  maxLines: 5,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: _buildDropdown(
                  label: "Select User",
                  value: _selectedUser,
                  items: _usernames,
                  onChanged: (value) {
                    setState(() {
                      _selectedUser = value;
                      _updateFormValidity();
                    });
                  },
                  validator: dropdownValidator,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18.0, right: 18.0),
                child: Divider(thickness: 0.1),
              ),
              const Text("OR"),
              const Text("Can Select Pre-defined Message"),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: predefinedMessages.map((message) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(message),
                        onTap: () {
                          _addPredefinedMessage(message);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
        ),
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
