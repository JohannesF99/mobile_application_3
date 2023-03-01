import 'package:flutter/material.dart';
import 'package:mobile_application_3/model/Note.dart';

class AddNotesButton extends StatefulWidget {
  const  AddNotesButton({
    super.key, 
    required this.onSave,
  });

  final void Function(Note) onSave;

  @override
  State<StatefulWidget> createState() => _AddNotesButton();
}

class _AddNotesButton extends State<AddNotesButton> {
  
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return BottomSheet(
            backgroundColor: Colors.black54,
            onClosing: () {},
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 10, color: Colors.transparent),
                    const Text(
                      "Neue Notiz hinzufügen",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const Divider(height: 10, color: Colors.transparent),
                    const Divider(height: 5, color: Colors.white),
                    const Divider(height: 10, color: Colors.transparent),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Titel',
                      ),
                    ),
                    const Divider(height: 10, color: Colors.transparent),
                    TextField(
                      controller: _bodyController,
                      minLines: 12,
                      maxLines: 15,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Inhalt',
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: TextButton(
                          onPressed: _areFieldsEmpty() ? null : () {
                            final note = Note(
                                title: _titleController.text.trim(),
                                body: _bodyController.text.trim(),
                            );
                            widget.onSave(note);
                            Navigator.pop(context);
                          },
                          child: const Text("Speichern")
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              );
            },
          );
        },
      ).whenComplete(() => _clearTexts()),
      icon: const Icon(Icons.add)
    );
  }

  bool _areFieldsEmpty() => _titleController.text.trim().isEmpty || _bodyController.text.trim().isEmpty;
  
  void _clearTexts() => Future.delayed(const Duration(milliseconds: 500), () {
    _titleController.clear();
    _bodyController.clear();
  });
}