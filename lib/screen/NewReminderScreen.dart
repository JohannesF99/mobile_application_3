import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mobile_application_3/util/DateTimeUtil.dart';

import '../model/Reminder.dart';

class NewReminderScreen extends StatefulWidget{
  const NewReminderScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NewReminderScreen();
}

class _NewReminderScreen extends State<NewReminderScreen> {

  final _nameController = TextEditingController();
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
          const Spacer(),
          TextButton(
            onPressed: _areFieldsEmpty() ? null : () {
              final reminder = Reminder(
                  title: _nameController.text.trim(),
                  date: _date!
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
  
  bool _areFieldsEmpty() => _nameController.text.trim().isEmpty || _date == null;
}