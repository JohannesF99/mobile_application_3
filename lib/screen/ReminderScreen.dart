import 'package:flutter/material.dart';
import 'package:mobile_application_3/database/NoteDB.dart';
import 'package:mobile_application_3/util/DateTimeUtil.dart';
import 'package:mobile_application_3/util/CountDownUtil.dart';
import 'package:mobile_application_3/widget/NoteList.dart';
import 'package:mobile_application_3/widget/DifficultyCircle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/Note.dart';
import '../model/Reminder.dart';
import '../widget/NotificationList.dart';

/// Zeigt Infos zu einem existierenden Termin an.
/// Erhält einen Termin im Konstruktor
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
      backgroundColor: const Color(0xFF1E202C),
      appBar: AppBar(
        title: Text(widget.reminder.title,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFF1E202C),
      ),
      body: Center(
        child: Column(
          children: [
            const Divider(height: 30, color: Colors.transparent),
            Card(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: const Color(0xFF1E202C),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                      Icons.access_alarm,
                      size: 50,
                  ),
                  Column(children: [
                      Text(widget.reminder.date.toReadable(
                        time: true,
                        am: AppLocalizations.of(context).on,
                        um: AppLocalizations.of(context).at,
                        stunde: AppLocalizations.of(context).hour
                      ),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Divider(height: 5, color: Colors.transparent),
                      CountDownUtil.fromDate(widget.reminder.date),
                  ],)
                ],
              ),
            ),
            const Divider(height: 30, color: Colors.transparent),
            Card(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              color: const Color(0xFF1E202C),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DifficultyCircle(difficulty: widget.reminder.difficulty),
                  Text(AppLocalizations.of(context).difficulty_of_the_exam,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Divider(indent: 10, color: Colors.transparent),
                ],
              ),
            ),
            const Divider(height: 20, color: Colors.transparent),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context).set_notifications,
                  style: const TextStyle(fontSize: 18)
                ),
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
                    height: 515,
                    notes: notes,
                    reminderId: widget.reminder.id!,
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }
            ),
          ],
        ),
      ),
    );
  }
}