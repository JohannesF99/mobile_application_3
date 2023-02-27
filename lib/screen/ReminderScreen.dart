import 'package:flutter/material.dart';
import 'package:mobile_application_3/database/NoteDB.dart';
import 'package:mobile_application_3/util/DateTimeUtil.dart';
import 'package:mobile_application_3/util/CountDownUtil.dart';
import 'package:mobile_application_3/widget/NoteList.dart';

import '../model/Note.dart';
import '../model/Reminder.dart';

class ReminderScreen extends StatefulWidget{
  const ReminderScreen({super.key, required this.reminder});

  final Reminder reminder;

  @override
  State<StatefulWidget> createState() => _ReminderScreen();
}

class _ReminderScreen extends State<ReminderScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.reminder.title),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          children: [
            const Divider(height: 20, color: Colors.transparent),
            Text(widget.reminder.date.toReadable()),
            CountDownUtil.inGerman(widget.reminder.date),
            const Divider(height: 20, color: Colors.transparent),
            FutureBuilder(
              future: NoteDB().getNotesForReminder(widget.reminder.id!),
              builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
                if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                  final notes = snapshot.data!;
                  return NoteList(notes: notes);
                }
                return const Center(child: CircularProgressIndicator());
              }),
          ],
        ),
      )
    );
  }
}