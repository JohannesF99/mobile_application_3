import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mobile_application_3/enum/Difficulty.dart';
import 'package:mobile_application_3/util/DateTimeUtil.dart';
import 'package:mobile_application_3/widget/DifficultyCircle.dart';

import '../model/Reminder.dart';

class NewReminderScreen extends StatefulWidget{
  const NewReminderScreen({super.key, required this.existing});

  final List<String> existing;

  @override
  State<StatefulWidget> createState() => _NewReminderScreen();
}

class _NewReminderScreen extends State<NewReminderScreen> {

  final _nameController = TextEditingController();
  Difficulty? _value;
  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Neuen Termin hinzufügen"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
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
                child: _date != null ? Text(_date!.toReadable(time: true)) : const Text("Noch kein Datum festgelegt."),
              ),
              const Spacer()
            ],
          ),
          const Divider(height: 30, color: Colors.transparent),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Potentielle Schwierigkeit der Klausur:"),
              const Divider(indent: 20, color: Colors.transparent),
              DropdownButton(
                  value: _value,
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
          const Spacer(),
          TextButton(
            onPressed: _areFieldsEmpty() ? null : () {
              final reminder = Reminder(
                  title: _nameController.text.trim(),
                  date: _date!,
                  difficulty: _value!,
              );
              Navigator.pop(context, reminder);
            },
            child: const Text("Speichern")
          ),
          const Divider(height: 30, color: Colors.transparent)
        ],
      ),
    );
  }

  bool _areFieldsEmpty() =>
      _nameController.text.trim().isEmpty ||
      widget.existing.contains(_nameController.text.trim()) ||
      _date == null;
}