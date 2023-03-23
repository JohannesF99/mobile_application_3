import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mobile_application_3/database/NoteDB.dart';
import 'package:mobile_application_3/enum/Difficulty.dart';
import 'package:mobile_application_3/util/DateTimeUtil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_application_3/widget/NoteList.dart';
import 'package:mobile_application_3/widget/DifficultyCircle.dart';
import '../database/ReminderDB.dart';
import '../model/Note.dart';
import '../model/Reminder.dart';
import '../util/Notifier.dart';

/// Bildschirm, um neue Termine zu erstellen
/// Bekommt eine Liste an existierenden Termin-Namen übergeben,
/// um doppelte Namen zu vermeiden.
class NewReminderScreen extends StatefulWidget{
  const NewReminderScreen({super.key, required this.existing});

  final List<String> existing;

  @override
  State<StatefulWidget> createState() => _NewReminderScreen();
}

class _NewReminderScreen extends State<NewReminderScreen> {

  /// Datenbank-Verbindung um Termine hinzuzufügen
  final _reminderDb = ReminderDB();
  /// Datenbank-Verbindung um Notizen hinzuzufügen
  final _noteDb = NoteDB();
  /// Liste aller Notizen, am Anfang leer, kann aber wachsen
  final _notes = List<Note>.empty(growable: true);
  /// TextController, um den Namen des Termins zu speichern
  final _nameController = TextEditingController();
  /// Schwietigkeit des Termins
  Difficulty? _value;
  /// Datum des Termins
  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF1E202C),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).create_new_appointment
        ),
        backgroundColor: const Color(0xFF1E202C),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 380,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFF676f98),
              ),
            ),
            child:
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              /// Textfeld für den Namen des Termins
              child: TextField(
                maxLength: 25,
                style: const TextStyle(
                  fontSize: 22
                ),
                decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context).appointment_name,
                ),
                onChanged: (_) => setState(() {}),
                controller: _nameController,
              ),
            )
          ),
          Container(
            width: 380,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFF676f98),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                IconButton(
                  /// Öffnet das PlugIn zur Auswahl der Zeit und des Datums
                  onPressed: () async {
                    final dateTime = await DatePicker.showDateTimePicker(
                        context,
                        minTime: DateTime.now(),
                        locale: LocaleType.values.byName(AppLocalizations.of(context).localeName),
                        currentTime: DateTime.now(),
                        theme: const DatePickerTheme(
                          backgroundColor: Color(0xFF1E202C),
                          containerHeight: 250,
                          titleHeight: 36,
                          itemHeight: 44,
                          doneStyle: TextStyle(
                              fontSize: 22,
                              color: Colors.white
                          ),
                          cancelStyle: TextStyle(
                              fontSize: 22,
                              color: Colors.white
                          ),
                          itemStyle: TextStyle(
                              fontSize: 22,
                              color: Colors.white
                          ),
                        )
                    );
                    /// Prüft, ob das ausgewählte Datum in der Vergangenheit list
                    /// und zeigt ggfs. einen Fehler an
                    if (dateTime == null || dateTime.isBefore(DateTime.now())) {
                      _date = null;
                      var alert = SnackBar(content: Text(AppLocalizations.of(context).the_appointment_is_in_the_past));
                      Future.delayed(Duration.zero).then((_) => ScaffoldMessenger.of(context).showSnackBar(alert));
                    }
                    /// Speichert das Datum
                    setState(() {
                      dateTime != null && dateTime.isAfter(DateTime.now()) ? _date = dateTime : null;
                    });
                  },
                  icon: const Icon(Icons.edit_calendar, size: 30,),
                ),
                const Spacer(),
                /// Zeigt das ausgewählte Datum an
                SizedBox(
                  child: _date != null ? Text(_date!.toReadable(
                      time: true, am: AppLocalizations.of(context).on,
                      um: AppLocalizations.of(context).at,
                      stunde: AppLocalizations.of(context).hour),
                    style: const TextStyle(fontSize: 22),
                  ) : Text(AppLocalizations.of(context).no_date_set_yet,
                    style: const TextStyle(fontSize: 19),
                  ),
                ),
                const Spacer()
              ],
            ),
          ),
          const Divider(height: 0, color: Colors.transparent),
          Container(
            height: 60,
            width: 380,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFF676f98),
              ),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context).potential_difficulty_of_the_exam, style: const TextStyle(fontSize: 15),),
                  const Divider(indent: 20, color: Colors.transparent),
                  /// Dropdown Liste, um die Schwierigkeit auszuwählen
                  DropdownButton(
                      value: _value,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: Difficulty.easy,
                          child: DifficultyCircle(difficulty: Difficulty.easy)
                        ),
                        DropdownMenuItem(
                          value: Difficulty.moderate,
                          child: DifficultyCircle(difficulty: Difficulty.moderate)
                        ),
                        DropdownMenuItem(
                          value: Difficulty.difficult,
                          child: DifficultyCircle(difficulty: Difficulty.difficult)
                        ),
                      ],
                      onChanged: (value){
                        setState(() {
                          _value = value!;
                        });
                      },
                  )
                ],
              ),
          ),
          const Divider(height: 20, color: Colors.transparent),
          NoteList(notes: _notes, height: 435,),
          const Spacer(),
          Container(
            width: 380,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFF676f98),
              ),
            ),
            child: Center(
              /// Button zum Speichern des Termins
              child: TextButton(
                /// Falls Felder nicht ausgeführt sein sollten, wird der Button
                /// ausgegraut.
                /// Ansonsten wir aus den Daten ein Termin-Objekt erstellt.
                  onPressed: _areFieldsEmpty() ? null : () async {
                    final reminder = Reminder(
                        title: _nameController.text.trim(),
                        date: _date!,
                        difficulty: _value!,
                    );
                    /// Speichert Termin in der Datenbank
                    final id = await _persistReminder(reminder);
                    /// Falls Persistierung fehlschlägt, zeige Fehler an und
                    /// return
                    if (id == 0) {
                      Future.delayed(Duration.zero).whenComplete(() => ReminderDB.showError(context));
                      return;
                    }
                    /// Erstelle die Benachrichtigungen für den Termin
                    Notifier.create(reminder);
                    /// Speichere die Notizen für den Termin
                    final errorsOccurred = await _persistNotes(_notes, id);
                    /// Falls das Speichern fehlschlägt, zeige Error an.
                    errorsOccurred ? Future.delayed(Duration.zero).whenComplete(() => NoteDB.showError(context)) : null;
                    Future.delayed(Duration.zero).whenComplete(() => Navigator.pop(context, reminder));
                  },
                  child: Text(
                      AppLocalizations.of(context).save,
                    style: const TextStyle(fontSize: 22),
                  )
              ),
            ),
          ),
          const Divider(height: 15, color: Colors.transparent)
        ],
      ),
    );
  }

  /// Prüft, ob der Termin einen Namen hat, ib der Name eindeutig ist,
  /// ob eine Schwierigkeit festgelegt wurde und ob ein Datum gesetzt wurde.
  bool _areFieldsEmpty() =>
      _nameController.text.trim().isEmpty ||
      widget.existing.contains(_nameController.text.trim()) ||
      _value == null ||
      _date == null;

  /// Hilfsfunktion, um Termin zu speichern.
  Future<int> _persistReminder(Reminder reminder) async =>
      (await _reminderDb.insert(reminder)).id ?? 0;

  /// Hilfsfunktion, um Notizen zu speichern.
  Future<bool> _persistNotes(List<Note> notes, int id) async {
    final idList = notes.map((e) => e.setReminderId(id)).toList();
    bool errorsOccurred = false;
    for (var note in idList) {
      ((await _noteDb.insert(note)).id ?? 0) == 0 ? errorsOccurred = true : null;
    }
    return errorsOccurred;
  }
}