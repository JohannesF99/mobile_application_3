import 'package:flutter/material.dart';
import 'package:mobile_application_3/database/NoteDB.dart';
import 'package:mobile_application_3/screen/NewReminderScreen.dart';
import 'package:mobile_application_3/widget/ReminderTile.dart';

import '../database/ReminderDB.dart';
import '../model/Reminder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  final _reminderDb = ReminderDB();
  final _noteDb = NoteDB();
  late List<Reminder> _reminderList;

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
      body: FutureBuilder(
        future: _reminderDb.getAll(),
        builder: (BuildContext context, AsyncSnapshot<List<Reminder>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _reminderList = snapshot.data ?? [];
            return ListView.builder(
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
                                    onPressed: () async {
                                      final affected = await _reminderDb.delete(_reminderList[i].id!);
                                      if (affected == 0) {
                                        Future.delayed(Duration.zero).whenComplete(() => ReminderDB.showError(context));
                                      } else {
                                        final notes = await _noteDb.getNotesForReminder(_reminderList[i].id!);
                                        for (var element in notes) {
                                          _noteDb.delete(element.id!);
                                        }
                                        setState(() {
                                          _reminderList.removeAt(i);
                                        });
                                      }
                                      Future.delayed(Duration.zero).whenComplete(() => Navigator.pop(context));
                                    },
                                    child: const Text("OK")
                                ),
                              ],
                            )
                        )
                    )
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}