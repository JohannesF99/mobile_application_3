import '../model/Note.dart';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class NoteDB {
  final _name = "Note";
  late Database _db;
  static final NoteDB _instance = NoteDB._internal();
  
  factory NoteDB() => _instance;

  NoteDB._internal();
  
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

  Future<Note> insert(Note note) async {
    note.id = await _db.insert(_name, note.toMap());
    return note;
  }

  Future<List<Note>> getNotesForReminder(int id) async {
    List<Map<String, Object?>> maps = await _db.query(_name,
        columns: ["_id", "reminderId", "title", "body"],
        where: 'reminderId = ?',
        whereArgs: [id]);
    return maps.map((e) => Note.fromMap(e)).toList();
  }

  Future<List<Note>> getAll() async {
    List<Map<String, Object?>> maps = await _db.query(_name,
        columns: ["_id", "reminderId", "title", "body"]);
    return maps.map((e) => Note.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    return await _db.delete(_name, where: '_id = ?', whereArgs: [id]);
  }

  Future<int> update(Note note) async {
    return await _db.update(
        _name,
        note.toMap(),
        where: '_id = ?',
        whereArgs: [note.id]
    );
  }

  Future close() async => _db.close();

  static void showError(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Es ist ein Fehler bei den Notizen aufgetreten!")
    ));
  }
}