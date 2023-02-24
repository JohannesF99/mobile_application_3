import 'package:flutter/material.dart';
import 'package:mobile_application_3/util/DateTimeUtil.dart';
import 'package:mobile_application_3/util/CountDownUtil.dart';
import 'package:mobile_application_3/widget/DifficultyCircle.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Schwierigkeit der Klausur:"),
                const Divider(indent: 10, color: Colors.transparent),
                DifficultyCircle(difficulty: widget.reminder.difficulty),
              ],
            )
          ],
        ),
      )
    );
  }
}