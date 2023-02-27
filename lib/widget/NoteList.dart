import 'package:flutter/material.dart';
import 'package:mobile_application_3/widget/AddNotesButton.dart';

import '../model/Note.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key, required this.notes});

  final List<Note> notes;

  @override
  State<StatefulWidget> createState() => _NoteList();
}

class _NoteList extends State<NoteList> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              "Notizen:",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height-316,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()
              ),
              shrinkWrap: true,
              itemCount: widget.notes.length+1,
              itemBuilder: (BuildContext context, int i) {
                if (widget.notes.length == i) {
                  return AddNotesButton(
                    onSave: (Note newNote) => setState(() {
                      widget.notes.add(newNote);
                    }),
                  );
                }
                return Card(
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
                );
              },
            ),
          )
        ],
      ),
    );
  }
}