import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app_april/view/notes_screen/notes_screen.dart';

class NoteOpenScreen extends StatefulWidget {
  const NoteOpenScreen({
    super.key,
    required this.title,
    required this.desc,
    required this.date,
    required this.noteColor,
    required this.noteKey,
    required this.noteBox,
  });

  final String title;
  final String desc;
  final String date;
  final Color noteColor;
  final int noteKey;
  final Box noteBox;

  @override
  State<NoteOpenScreen> createState() => _NoteOpenScreenState();
}

class _NoteOpenScreenState extends State<NoteOpenScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController descController = TextEditingController();
    TextEditingController titleController = TextEditingController();

    descController.text = widget.desc;
    titleController.text = widget.title;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              widget.noteBox.put(widget.noteKey, {
                "title": titleController.text,
                "desc": descController.text,
                "colorIndex": widget.noteColor,
                "date": widget.date,
              });
              setState(() {});
              print(widget.noteBox.get(widget.noteKey));
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => NotesScreen()));
            },
            child: Icon(Icons.arrow_back_ios_new),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(child: Text("Save")),
                  PopupMenuItem(child: Text("Settings")),
                  PopupMenuItem(child: Text("Close")),
                ];
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(color: widget.noteColor),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textAlign: TextAlign.justify,
              controller: descController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(enabledBorder: OutlineInputBorder()),
            ),
          ),
        ));
  }
}
