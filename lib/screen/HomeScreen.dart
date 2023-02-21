import 'package:flutter/material.dart';
import 'package:mobile_application_3/screen/NewReminderScreen.dart';
import 'package:mobile_application_3/widget/ReminderTile.dart';

import '../model/Reminder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  final _reminderList = <Reminder>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Mobile Application 3"),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          final Reminder? newReminder = await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const NewReminderScreen())
          );
          setState(() {
            newReminder != null ? _reminderList.add(newReminder) : null;
          });
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _reminderList.length,
        itemBuilder: (context, i) =>
          ReminderTile(
            reminder: _reminderList[i],
            onLongPress: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Termin wird gelöscht?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Abbrechen")
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _reminderList.removeAt(i);
                          });
                          Navigator.pop(context);
                        },
                        child: const Text("OK")
                    ),
                  ],
                )
            )
          )
      ),
    );
  }
}