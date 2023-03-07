import 'package:flutter/material.dart';
import 'package:mobile_application_3/model/Note.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            backgroundColor: const Color(0xFF1E202C),
            onClosing: () {},
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 10, color: Colors.transparent),
                    Text(
                      AppLocalizations.of(context)!.add_new_note,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const Divider(height: 10, color: Colors.transparent),
                    const Divider(height: 5, color: Colors.white),
                    const Divider(height: 10, color: Colors.transparent),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        hintText: AppLocalizations.of(context)!.title,
                      ),
                    ),
                    const Divider(height: 10, color: Colors.transparent),
                    TextField(
                      controller: _bodyController,
                      minLines: 12,
                      maxLines: 12,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: AppLocalizations.of(context)!.content,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 380,
                      //margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color(0xFF676f98),
                        ),
                      ),
                      child: Center(
                        child: TextButton(

                            onPressed: _areFieldsEmpty() ? null : () {
                              final note = Note(
                                  title: _titleController.text.trim(),
                                  body: _bodyController.text.trim(),
                              );
                              widget.onSave(note);
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context)!.save,
                              style: const TextStyle(fontSize: 22),
                            )
                        ),
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