import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Reminder.dart';

class ReminderDB {
  final _name = "Reminder";
  late Database _db;
  static final ReminderDB _instance = ReminderDB._internal();

  factory ReminderDB() => _instance;

  ReminderDB._internal();
  
  Future open() async {
    _db = await openDatabase(
        "${_name.toLowerCase()}.db",
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $_name ( 
  _id integer primary key autoincrement, 
  title text unique not null,
  date text not null)
'''
          );
        });
  }

  Future<Reminder> insert(Reminder reminder) async {
    reminder.id = await _db.insert(_name, reminder.toMap());
    return reminder;
  }

  Future<Reminder> getReminder(String title) async {
    List<Map<String, Object?>> maps = await _db.query(_name,
        columns: ["_id", "title", "date"],
        where: 'title = ?',
        whereArgs: [title]);
    return Reminder.fromMap(maps.first);
  }

  Future<List<Reminder>> getAll() async {
    List<Map<String, Object?>> maps = await _db.query(_name,
        columns: ["_id", "title", "date"]);
    return maps.map((e) => Reminder.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    return await _db.delete(_name, where: '_id = ?', whereArgs: [id]);
  }

  Future<int> update(Reminder reminder) async {
    return await _db.update(
        _name,
        reminder.toMap(),
        where: '_id = ?',
        whereArgs: [reminder.id]
    );
  }

  Future close() async => _db.close();
  
  static void showError(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Es ist ein Fehler mit der Datenbank aufgetreten!")
    ));
  }
}