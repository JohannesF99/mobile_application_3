import 'package:flutter/material.dart';

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
        child: Text(widget.reminder.date.toIso8601String()),
      ),
    );
  }
}