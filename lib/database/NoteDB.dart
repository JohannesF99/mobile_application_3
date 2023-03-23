import '../model/Note.dart';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

/// Klasse für die Speicherung von Notizen mit SQFLite.
/// Ist ein Singelton, da zur Laufzeit immer nur eine Verbindung zur
/// Datenbank existieren soll.
class NoteDB {
  /// Name der Datenbank
  final _name = "Note";
  /// Datenbank-Verbindung
  late Database _db;
  /// Singelton-Instanz
  static final NoteDB _instance = NoteDB._internal();
  
  factory NoteDB() => _instance;

  NoteDB._internal();

  /// Öffnet die Verbindung zur Datenbank bzw. Erstellt sie, falls nicht vorhanden
  Future open() async {
    _db = await openDatabase(
        "${_name.toLowerCase()}.db",
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $_name ( 
  _id integer primary key autoincrement, 
  reminderId integer not null,
  title text not null,
  body text not null)
'''
          );
        });
  }

  /// Speichert ein Element in der Datenbank
  Future<Note> insert(Note note) async {
    note.id = await _db.insert(_name, note.toMap());
    return note;
  }

  /// Gibt alle Notizen für eine Termin-ID zurück.
  Future<List<Note>> getNotesForReminder(int id) async {
    List<Map<String, Object?>> maps = await _db.query(_name,
        columns: ["_id", "reminderId", "title", "body"],
        where: 'reminderId = ?',
        whereArgs: [id]);
    return maps.map((e) => Note.fromMap(e)).toList();
  }

  /// Erhalte alle Notizen der Datenbank
  Future<List<Note>> getAll() async {
    List<Map<String, Object?>> maps = await _db.query(_name,
        columns: ["_id", "reminderId", "title", "body"]);
    return maps.map((e) => Note.fromMap(e)).toList();
  }

  /// Lösche eine Notiz aus der Datenbank
  Future<int> delete(int id) async {
    return await _db.delete(_name, where: '_id = ?', whereArgs: [id]);
  }

  /// Update eine existierende Notiz in der Datenbank
  Future<int> update(Note note) async {
    return await _db.update(
        _name,
        note.toMap(),
        where: '_id = ?',
        whereArgs: [note.id]
    );
  }

  Future close() async => _db.close();

  /// Error zum Anzeigen, falls Fehler auftreten sollten.
  static void showError(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Es ist ein Fehler bei den Notizen aufgetreten!")
    ));
  }
}