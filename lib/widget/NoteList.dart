import 'package:flutter/material.dart';
import 'package:mobile_application_3/database/NoteDB.dart';
import 'package:mobile_application_3/widget/AddNotesButton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/Note.dart';

/// Erstellt eine Notizenliste.
/// Bekommt eine Liste an Notizen, welche dargestellt werden & eine Höhe für
/// das Widget.
/// Optional kann eine Termin-ID mit übergeben werden, falls ein Termin schon existiert.
class NoteList extends StatefulWidget {
  const NoteList({
    super.key, 
    required this.notes,
    required this.height,
    this.reminderId
  });

  final List<Note> notes;
  final int height;
  final int? reminderId;

  @override
  State<StatefulWidget> createState() => _NoteList();
}

class _NoteList extends State<NoteList> {

  /// Eine Instanz der Notizdatenbank, um Notizen zu speichern.
  final _noteDb = NoteDB();
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Überschrift
          Text(
            AppLocalizations.of(context)!.notes,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            //height: MediaQuery.of(context).size.height-435,
            height: MediaQuery.of(context).size.height-widget.height,
            /// Ein Builder, welcher alle Elemente der im Konstruktor übergebenen
            /// List an Notizen darstellt.
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()
              ),
              shrinkWrap: true,
              /// Anzahl an Items ist eins höher als eigentlich Elemente in der
              /// Liste existieren, da als letztes, neben den eigentlichen Notizen
              /// noch ein Button zum hinzufügen neuer Notizen exisiteren soll.
              itemCount: widget.notes.length+1,
              itemBuilder: (BuildContext context, int i) {
                if (widget.notes.length == i) {
                  /// Nachdem alle Notizen dargestellt wurde, zeige den Button an.
                  return AddNotesButton(
                    /// Funktion zum Speichern wird definiert.
                    /// Falls die Notizen schon zu einem existierenden Termin
                    /// gehören, dann füge die Termin-ID zur Notiz hinzu.
                    /// Anschließend speichere die Notiz in der Datenbank.
                    /// Sollte das Speichern fehlschlafen, zeige eine Fehler-
                    /// nachricht an.
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
                      /// Falls keine Termin-ID im Konstruktor übergeben wurde,
                      /// existiert noch kein Termin für die Notizen.
                      /// In diesem Fall füge die Notiz nur zu der List hinzu,
                      /// damit sich das Parent-Widget um das Speichern kümmern
                      /// kann
                      setState(() {
                        widget.notes.add(newNote);
                      });
                    },
                  );
                }
                /// Zeige eine Notiz an
                return InkWell(
                  /// Falls lange auf die Notiz gedrückt wird, zeige einen
                  /// Dialog an, um die Notiz wieder zu löschen.
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
                  /// Beschreibt den Inhalt der Notiz.
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
                          /// Der Titel der Notiz
                          Text(
                            widget.notes[i].title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          /// Der Inhalt der Notiz
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