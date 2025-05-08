
/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class NoteModel {
  final String noteId;
  final String noteTitle;
  final String noteContent;
  final String createdAt;
  final String username; 
  final String to;

  NoteModel({
    required this.noteId,
    required this.noteTitle,
    required this.noteContent,
    required this.createdAt,
    required this.username,
    required this.to,
  });

  factory NoteModel.fromMap(Map<String, dynamic> json) => NoteModel(
    noteId: json["noteId"],
    noteTitle: json["noteTitle"],
    noteContent: json["noteContent"],
    createdAt: json["createdAt"],
    username: json["username"],
    to: json["to"],
  );

  Map<String, dynamic> toMap() => {
    "noteId": noteId,
    "noteTitle": noteTitle,
    "noteContent": noteContent,
    "createdAt": createdAt,
    "username": username,
    "to": to,
  };
}
