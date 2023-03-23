import 'package:flutter/material.dart';
import 'package:mobile_application_3/model/Note.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Ein Button-Widget, welcher eine Notiz zur Erinnerung erstellt..
/// Bekommt eine Funktion [onSave] übergeben, welche vom Parent-Widget
/// definiert werden muss & festlegt, wie mit der erstellten Notiz umgegangen
/// werden soll
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

  /// Controller für den Titel der Notiz.
  final _titleController = TextEditingController();
  /// Controller für den Inhalt der Notiz.
  final _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /// Gibt grundsätzlich ein normalen IconButton mit vordefinierter
    /// [onPressed] Funktion zurück.
    return IconButton(
      /// Auf Button-Druck wird ein Dialog geöffnet.
      /// Wenn der Dialog geschlossen wird, werden die Inhalte der TextController
      /// gelöscht (siehe Zeile 113). Dafür ist eigentlich die [onClosing] Funktion zuständig.
      /// Wegen eines bekannten Flutter-Bugs, funktioniert diese Methode
      /// jedoch leider nicht.
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
                    /// Überschrift
                    Text(
                      AppLocalizations.of(context).add_new_note,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const Divider(height: 10, color: Colors.transparent),
                    const Divider(height: 5, color: Colors.white),
                    const Divider(height: 10, color: Colors.transparent),
                    /// Textfeld für die Überschrift der Notiz
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        hintText: AppLocalizations.of(context).title,
                      ),
                    ),
                    const Divider(height: 10, color: Colors.transparent),
                    /// Textfeld für den Inhalt der Notiz
                    TextField(
                      controller: _bodyController,
                      minLines: 12,
                      maxLines: 12,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: AppLocalizations.of(context).content,
                      ),
                    ),
                    const Spacer(),
                    /// Button zum Speichern
                    Container(
                      width: 380,
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
                              /// Hier wird die im Konstruktor übergebene Funktion
                              /// mit der soeben erstellten Notiz aufgerufen.
                              widget.onSave(note);
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context).save,
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

  /// Hilfsfunktion, welche checkt, ob Überschrift & Inhalt der Notiz gefüllt sind.
  /// Nur wenn beide Textfelder befüllt sind, kann die Notiz erstellt werden.
  /// Ansonsten soll der Speicher-Knopf ausgegraut sein. (siehe Zeile 96)
  bool _areFieldsEmpty() => _titleController.text.trim().isEmpty || _bodyController.text.trim().isEmpty;

  /// Hilfsfunktion, welche den Inhalt der Textcontroller löscht, ohne die Controller an sich zu verwerfen.
  void _clearTexts() => Future.delayed(const Duration(milliseconds: 500), () {
    _titleController.clear();
    _bodyController.clear();
  });
}