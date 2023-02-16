import 'package:flutter/material.dart';

import '../model/Reminder.dart';
import '../screen/ReminderScreen.dart';

class ReminderTile extends StatelessWidget{
  const ReminderTile({super.key, required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ReminderScreen(reminder: reminder))
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height/10,
        child: Card(
          child: Center(
            child: Text(reminder.title),
          ),
        ),
      ),
    );
  }
}