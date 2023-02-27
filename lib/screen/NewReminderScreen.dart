import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mobile_application_3/database/NoteDB.dart';
import 'package:mobile_application_3/util/DateTimeUtil.dart';
import 'package:mobile_application_3/widget/NoteList.dart';

import '../database/ReminderDB.dart';
import '../model/Note.dart';
import '../model/Reminder.dart';

class NewReminderScreen extends StatefulWidget{
  const NewReminderScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NewReminderScreen();
}

class _NewReminderScreen extends State<NewReminderScreen> {

  final _reminderDb = ReminderDB();
  final _noteDb = NoteDB();
  final _notes = List<Note>.empty(growable: true);
  final _nameController = TextEditingController();
  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Neuen Termin hinzufügen"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextField(
              maxLength: 25,
              decoration: const InputDecoration(
                  hintText: "Termin-Name"
              ),
              onChanged: (_) => setState(() {}),
              controller: _nameController,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              IconButton(
                onPressed: () async {
                  final dateTime = await DatePicker.showDateTimePicker(context,
                      locale: LocaleType.de,
                      currentTime: DateTime.now(),
                      theme: const DatePickerTheme(
                        backgroundColor: Colors.black,
                        doneStyle: TextStyle(
                            color: Colors.white
                        ),
                        cancelStyle: TextStyle(
                            color: Colors.white
                        ),
                        itemStyle: TextStyle(
                            color: Colors.white
                        ),
                      )
                  );
                  if (dateTime == null || dateTime.isBefore(DateTime.now())) {
                    _date = null;
                    const alert = SnackBar(content: Text("Der Termin liegt in der Vergangenheit!"));
                    Future.delayed(Duration.zero).then((_) => ScaffoldMessenger.of(context).showSnackBar(alert));
                  }
                  setState(() {
                    dateTime != null && dateTime.isAfter(DateTime.now()) ? _date = dateTime : null;
                  });
                },
                icon: const Icon(Icons.edit_calendar),
              ),
              const Spacer(),
              SizedBox(
                child: _date != null ? Text(_date!.toReadable()) : const Text("Noch kein Datum festgelegt."),
              ),
              const Spacer()
            ],
          ),
          const Divider(height: 20, color: Colors.transparent),
          NoteList(notes: _notes),
          const Spacer(),
          Center(
            child: TextButton(
                onPressed: _areFieldsEmpty() ? null : () async {
                  final reminder = Reminder(
                      title: _nameController.text.trim(),
                      date: _date!
                  );
                  final id = await _persistReminder(reminder);
                  if (id == 0) {
                    Future.delayed(Duration.zero).whenComplete(() => ReminderDB.showError(context));
                    return;
                  }
                  final errorsOccurred = await _persistNotes(_notes, id);
                  errorsOccurred ? Future.delayed(Duration.zero).whenComplete(() => NoteDB.showError(context)) : null;
                  Future.delayed(Duration.zero).whenComplete(() => Navigator.pop(context, reminder));
                },
                child: const Text("Speichern")
            ),
          ),
          const Divider(height: 30, color: Colors.transparent)
        ],
      ),
    );
  }
  
  bool _areFieldsEmpty() => _nameController.text.trim().isEmpty || _date == null;

  Future<int> _persistReminder(Reminder reminder) async =>
      (await _reminderDb.insert(reminder)).id ?? 0;

  Future<bool> _persistNotes(List<Note> notes, int id) async {
    final idList = notes.map((e) => e.setReminderId(id)).toList();
    bool errorsOccurred = false;
    for (var note in idList) {
      ((await _noteDb.insert(note)).id ?? 0) == 0 ? errorsOccurred = true : null;
    }
    return errorsOccurred;
  }
}