// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:note_app_april/dummy_db.dart';
import 'package:note_app_april/utils/app_sessions.dart';
import 'package:note_app_april/utils/color_constants/color_constants.dart';
import 'package:note_app_april/view/note_open_screen/note_open_screen.dart';
import 'package:note_app_april/view/notes_screen/widget/note_card.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key, this.noteKeyInt});

  final int? noteKeyInt;

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  int selectedColorIndex = 0;
  int selectedIndex = 0;

  //step 2
  var noteBox = Hive.box(AppSessions.NOTEBOX);

  //to store keys from the hive
  List noteKeys = [];

  //init state will be used here to get all the keys from the hive, store it in the noteKeys list
  // and make the values corresponding to the keys visible in UI once the app is opening

  @override
  void initState() {
    noteKeys = noteBox.keys.toList();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.grey.shade300,
            onPressed: () {
              titleController.clear();
              descController.clear();
              dateController.clear();
              selectedColorIndex = 0;
              _customBottomSheet(context);
            },
            child: Icon(Icons.add),
          ),
          body: ListView.separated(
              padding: EdgeInsets.all(15),
              itemBuilder: (context, index) {
                //this variable is to pick the data in the index from the hive
                var currentNote = noteBox.get(noteKeys[index]);
                return InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NoteOpenScreen(
                                  title: currentNote["title"],
                                  desc: currentNote["desc"],
                                  date: currentNote["date"],
                                  noteColor: DummyDb
                                      .noteColors[currentNote["colorIndex"]],
                                  noteKey: noteKeys[index],
                                  noteBox: noteBox,
                                )));
                  },
                  child: NoteCard(
                    noteColor: DummyDb.noteColors[currentNote["colorIndex"]],
                    date: currentNote["date"],
                    desc: currentNote["desc"],
                    title: currentNote["title"],
                    //deletion
                    onDelete: () {
                      noteBox.delete(noteKeys[index]);
                      noteKeys = noteBox.keys.toList();
                      setState(() {});
                    },
                    //editing
                    onEdit: () {
                      titleController.text = currentNote["title"];
                      dateController.text = currentNote["date"];
                      descController.text = currentNote["desc"];
                      selectedColorIndex = currentNote["colorIndex"];

                      _customBottomSheet(context,
                          isEdit: true, itemIndex: index);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
              itemCount: noteKeys.length)),
    );
  }

  Future<dynamic> _customBottomSheet(BuildContext context,
      {bool isEdit = false, int? itemIndex}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Padding(
              padding: const EdgeInsets.all(20),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                          hintText: "Title",
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: descController,
                      maxLines: 5,
                      decoration: InputDecoration(
                          hintText: "Description",
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      readOnly: true,
                      controller: dateController,
                      decoration: InputDecoration(
                          hintText: "Date",
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                              onPressed: () async {
                                var selectedDate = await showDatePicker(
                                    //assigning the selected date here
                                    context: context,
                                    firstDate: DateTime(2021),
                                    lastDate: DateTime.now());

                                if (selectedDate != null) {
                                  dateController.text = DateFormat("dd MMMM y")
                                      .format(selectedDate);
                                }
                              },
                              icon: Icon(Icons.calendar_month))),
                    ),
                    SizedBox(height: 20),
                    //build color section
                    StatefulBuilder(
                      builder: (context, setColorState) => Row(
                        children: List.generate(
                          DummyDb.noteColors.length,
                          (index) => Expanded(
                            child: InkWell(
                              onTap: () {
                                selectedColorIndex = index;
                                setColorState(
                                  () {},
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                height: 50,
                                decoration: BoxDecoration(
                                    border: selectedColorIndex == index
                                        ? Border.all(width: 3)
                                        : null,
                                    color: DummyDb.noteColors[index],
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorConstants.mainRed,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (isEdit == true) {
                                noteBox.put(noteKeys[itemIndex!], {
                                  "title": titleController.text,
                                  "desc": descController.text,
                                  "colorIndex": selectedColorIndex,
                                  "date": dateController.text,
                                });
                              } else {
                                //to add new note to hive storage
                                //step 3
                                noteBox.add({
                                  "title": titleController.text,
                                  "desc": descController.text,
                                  "date": dateController.text,
                                  "colorIndex": selectedColorIndex
                                });
                              }
                              noteKeys = noteBox.keys
                                  .toList(); //to update the key list after adding a note
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorConstants.mainGreen,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                isEdit ? "Update" : "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }
}
