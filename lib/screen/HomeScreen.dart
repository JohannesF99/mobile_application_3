import 'package:flutter/material.dart';
import 'package:mobile_application_3/database/NoteDB.dart';
import 'package:mobile_application_3/screen/NewReminderScreen.dart';
import 'package:mobile_application_3/util/Notifier.dart';
import 'package:mobile_application_3/widget/ReminderTile.dart';
import 'package:mobile_application_3/screen/LanguageSelect.dart';
import '../database/ReminderDB.dart';
import '../model/Reminder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Die Hauptseite der App. Erhält eine Funktion zum Ändern der Sprache im
/// Konstruktor.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onLocalChange});

  final void Function(Locale locale) onLocalChange;

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  /// Datenbank-Verbindung zum Verarbeiten von Terminen
  final _reminderDb = ReminderDB();
  /// Datenbank-Verbindung zum Verarbeiten von Notizen
  final _noteDb = NoteDB();
  /// Liste von Terminen
  late List<Reminder> _reminderList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E202C),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).exam_planer, style: const TextStyle(fontSize: 24),),
        backgroundColor: const Color(0xFF1E202C),
      ),
      /// Seitenmenu zur Auswahl der Sprache
      drawer: Drawer(
        backgroundColor: const Color(0xFF1E202C),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 110,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF1E202C),
                ),
                child: Text(
                  AppLocalizations.of(context).settings,
                  style: const TextStyle(
                      fontSize: 28
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.language,
              ),
              title: Text(
                AppLocalizations.of(context).language,
                style: const TextStyle(
                  fontSize: 20
                )
              ),
              onTap:() async {
                final String? languageCode = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LanguageSelectScreen()),
                );
                if(languageCode != null) {
                  widget.onLocalChange(Locale(languageCode));
                }//Navigator.pop(context);
              }
            )
          ],
        ),
      ),
      /// Button zum Hinzufügen von neuen Terminen
      /// Ruft den [NewReminderScreen] auf
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          final Reminder? newReminder = await Navigator.push(context,
              MaterialPageRoute(builder: (_) => NewReminderScreen(
                  existing: _reminderList.map((e) => e.title).toList()
              ))
          );
          setState(() {
            newReminder == null ? null : _reminderList.add(newReminder);
          });
        },
        child: const Icon(Icons.add),
      ),
      /// Holt sich asynchron die Termine aus der Datenbank, um sie anschließend
      /// mit einem [ListView.builder] darzustellen.
      body: FutureBuilder(
        future: _reminderDb.getAll(),
        builder: (BuildContext context, AsyncSnapshot<List<Reminder>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _reminderList = snapshot.data ?? [];
            return ListView.builder(
                itemCount: _reminderList.length,
                itemBuilder: (context, i) =>
                    /// Erstellt für jeden Termin ein [ReminderTile] mit dem Inhalt
                    /// des Termins
                    ReminderTile(
                        reminder: _reminderList[i],
                        /// Auf den langen Druck wird ein Dialog geöffnet, welcher
                        /// den Nutzer fragt, ob er den Eintrag löschen möchte
                        onLongPress: () => showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(AppLocalizations.of(context).appointment_will_be_deleted),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(AppLocalizations.of(context).cancel)
                                ),
                                TextButton(
                                    onPressed: () async {
                                      final affected = await _reminderDb.delete(_reminderList[i].id!);
                                      if (affected == 0) {
                                        Future.delayed(Duration.zero).whenComplete(() => ReminderDB.showError(context));
                                      } else {
                                        Notifier.delete(_reminderList[i]);
                                        final notes = await _noteDb.getNotesForReminder(_reminderList[i].id!);
                                        for (var element in notes) {
                                          _noteDb.delete(element.id!);
                                        }
                                        setState(() {
                                          _reminderList.removeAt(i);
                                        });
                                      }
                                      Future.delayed(Duration.zero).whenComplete(() => Navigator.pop(context));
                                    },
                                    child: const Text("OK")
                                ),
                              ],
                            )
                        )
                    )
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}