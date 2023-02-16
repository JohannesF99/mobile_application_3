import 'package:flutter/material.dart';

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
          TextField(
            onChanged: (_) => setState(() {}),
            controller: _nameController,
          ),
          TextButton(
            onPressed: () async {
              final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100)
              );
              setState(() {
                date != null ? _date = date : null;
              });
            },
            child: const Text("Datum auswählen")
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