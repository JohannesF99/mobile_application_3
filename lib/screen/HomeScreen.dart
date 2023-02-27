import 'package:flutter/material.dart';
import 'package:mobile_application_3/screen/NewReminderScreen.dart';
import 'package:mobile_application_3/util/Notifier.dart';
import 'package:mobile_application_3/widget/ReminderTile.dart';
import 'package:mobile_application_3/screen/LanguageSelect.dart';
import '../database/ReminderDB.dart';
import '../model/Reminder.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key, required this.onLocalChange, required this.db});

  final ReminderDB db;
  final void Function(Locale locale) onLocalChange;

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  late final ReminderDB db;
  late List<Reminder> _reminderList;

  @override
  void initState() {
    db = widget.db;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Mobile Application 3"),
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.yellow,
              ),
              child: Text("Einstellungen"),
            ),
            ListTile(
              leading: const Icon(
                Icons.language,
              ),
              title: const Text('Sprache'),
              onTap:() async {
                final languageCode = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LanguageSelectScreen()),
                );
                widget.onLocalChange(Locale(languageCode.toString()));
                //Navigator.pop(context);
              }
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          final Reminder? newReminder = await Navigator.push(context,
              MaterialPageRoute(builder: (_) => NewReminderScreen(
                  existing: _reminderList.map((e) => e.title).toList()
              ))
          );
          if (newReminder != null) {
            final rem = await db.insert(newReminder);
            if (rem.id == 0) {
              Future.delayed(Duration.zero).then((value) => ReminderDB.showError(context));
            } else {
              Notifier.create(rem);
              setState(() {
                _reminderList.add(rem);
              });
            }
          }
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: db.getAll(),
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
                                      final affected = await db.delete(_reminderList[i].id!);
                                      if (affected == 0) {
                                        Future.delayed(Duration.zero).whenComplete(() => ReminderDB.showError(context));
                                      } else {
                                        Notifier.delete(_reminderList[i]);
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