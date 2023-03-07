import 'package:flutter/material.dart';
import 'package:mobile_application_3/database/NoteDB.dart';
import 'package:mobile_application_3/widget/AddNotesButton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/Note.dart';

class NoteList extends StatefulWidget {
  const NoteList({
    super.key, 
    required this.notes,
    this.reminderId
  });

  final List<Note> notes;
  final int? reminderId;

  @override
  State<StatefulWidget> createState() => _NoteList();
}

class _NoteList extends State<NoteList> {

  final _noteDb = NoteDB();
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.notes,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height-435,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()
              ),
              shrinkWrap: true,
              itemCount: widget.notes.length+1,
              itemBuilder: (BuildContext context, int i) {
                if (widget.notes.length == i) {
                  return AddNotesButton(
                    onSave: (Note newNote) async {
                      if (widget.reminderId != null) {
                        newNote.setReminderId(widget.reminderId!);
                        final id = (await _noteDb.insert(newNote)).id ?? 0;
                        if (id == 0) {
                          Future.delayed(Duration.zero).whenComplete(() => NoteDB.showError(context));
                          return;
                        }
                        newNote.id = id;
                      }
                      setState(() {
                        widget.notes.add(newNote);
                      });
                    },
                  );
                }
                return InkWell(
                  onLongPress: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.note_will_be_deleted),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(AppLocalizations.of(context)!.cancel)
                        ),
                        TextButton(
                            onPressed: () async {
                              if (widget.reminderId != null) {
                                final id = await _noteDb.delete(widget.notes[i].id!);
                                if (id == 0) {
                                  Future.delayed(Duration.zero).whenComplete(() => NoteDB.showError(context));
                                  Future.delayed(Duration.zero).whenComplete(() => Navigator.pop(context));
                                  return;
                                }
                              }
                              setState(() {
                                widget.notes.removeAt(i);
                              });
                              Future.delayed(Duration.zero).whenComplete(() => Navigator.pop(context));
                            },
                            child: const Text("OK")
                        ),
                      ],
                    ),
                  ),
                  child: Card(
                    elevation: 5,
                    color: const Color(0xFF1E202C),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(height: 5, color: Colors.transparent),
                          Text(
                            widget.notes[i].title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(widget.notes[i].body),
                          const Divider(height: 10, color: Colors.transparent),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}