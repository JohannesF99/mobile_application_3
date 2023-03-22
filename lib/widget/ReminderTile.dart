import 'package:flutter/material.dart';
import 'package:mobile_application_3/widget/DifficultyCircle.dart';
import '../model/Reminder.dart';
import '../screen/ReminderScreen.dart';

class ReminderTile extends StatelessWidget{
  const ReminderTile({super.key,
    required this.reminder,
    required this.onLongPress,
  });

  final Reminder reminder;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ReminderScreen(reminder: reminder))
      ),
      onLongPress: onLongPress,
      child: SizedBox(
        height: MediaQuery.of(context).size.height/10,
          child: Card(
            color: const Color(0xFF1E202C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 5,
            child: Stack(
              children: [
                Positioned(
                  child: Center(child: Text(
                      reminder.title,
                      style: const TextStyle(fontSize: 24),
                  ))
                ),
                Positioned(
                  bottom: 20,
                  right:20,
                  child: DifficultyCircle(difficulty: reminder.difficulty),
                ),
              ],
            )
          ),
        ),
    );
  }
}