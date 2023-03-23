import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Reminder.dart';

/// Klasse für die Speicherung von Terminen mit SQFLite.
/// Ist ein Singelton, da zur Laufzeit immer nur eine Verbindung zur
/// Datenbank existieren soll.
class ReminderDB {
  /// Name der Datenbank
  final _name = "Reminder";
  /// Datenbank-Verbindung
  late Database _db;
  /// Singelton-Instanz
  static final ReminderDB _instance = ReminderDB._internal();

  factory ReminderDB() => _instance;

  ReminderDB._internal();

  /// Öffnet die Verbindung zur Datenbank bzw. Erstellt sie, falls nicht vorhanden
  Future open() async {
    _db = await openDatabase(
        "${_name.toLowerCase()}.db",
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $_name ( 
  _id integer primary key autoincrement, 
  title text unique not null,
  date text not null,
  difficulty text not null)
'''
          );
       }
   );
  }

  /// Speichert ein Element in der Datenbank
  Future<Reminder> insert(Reminder reminder) async {
    reminder.id = await _db.insert(_name, reminder.toMap());
    return reminder;
  }

  /// Gibt den Termin aus der Datenbank zurück
  Future<Reminder> getReminder(String title) async {
    List<Map<String, Object?>> maps = await _db.query(_name,
        columns: ["_id", "title", "date", "difficulty"],
        where: 'title = ?',
        whereArgs: [title]);
    return Reminder.fromMap(maps.first);
  }

  /// Erhalte alle Termine der Datenbank
  Future<List<Reminder>> getAll() async {
    List<Map<String, Object?>> maps = await _db.query(_name,
        columns: ["_id", "title", "date", "difficulty"]);
    return maps.map((e) => Reminder.fromMap(e)).toList();
  }

  /// Lösche einen Termin aus der Datenbank
  Future<int> delete(int id) async {
    return await _db.delete(_name, where: '_id = ?', whereArgs: [id]);
  }

  /// Update einen existierenden Termin in der Datenbank
  Future<int> update(Reminder reminder) async {
    return await _db.update(
        _name,
        reminder.toMap(),
        where: '_id = ?',
        whereArgs: [reminder.id]
    );
  }

  Future close() async => _db.close();

  /// Error zum Anzeigen, falls Fehler auftreten sollten.
  static void showError(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Es ist ein Fehler mit der Datenbank aufgetreten!")
    ));
  }
}