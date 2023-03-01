import 'package:flutter/material.dart';
import 'package:mobile_application_3/database/NoteDB.dart';
import 'package:mobile_application_3/util/DateTimeUtil.dart';
import 'package:mobile_application_3/util/CountDownUtil.dart';
import 'package:mobile_application_3/widget/NoteList.dart';
import 'package:mobile_application_3/widget/DifficultyCircle.dart';
import 'package:mobile_application_3/widget/NotificationList.dart';


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
            Text(widget.reminder.date.toReadable(time: true)),
            CountDownUtil.inGerman(widget.reminder.date),
            const Divider(height: 20, color: Colors.transparent),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Schwierigkeit der Klausur:"),
                const Divider(indent: 10, color: Colors.transparent),
                DifficultyCircle(difficulty: widget.reminder.difficulty),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Eingestellte Benachrichtigungen:"),
                NotificationList(channel: widget.reminder.title),
              ],
            ),
            const Divider(height: 20, color: Colors.transparent),
            FutureBuilder(
              future: NoteDB().getNotesForReminder(widget.reminder.id!),
              builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
                if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                  final notes = snapshot.data!;
                  return NoteList(
                    notes: notes,
                    reminderId: widget.reminder.id!,
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }
            ),
          ],
        ),
      )
    );
  }
}