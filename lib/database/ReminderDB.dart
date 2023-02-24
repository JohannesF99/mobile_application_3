import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Reminder.dart';

class ReminderDB{
  late Database db;

  Future open() async {
    db = await openDatabase(
        "reminder.db",
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table Reminder ( 
  _id integer primary key autoincrement, 
  title text unique not null,
  date text not null,
  difficulty text not null)
'''
          );
        });
  }

  Future<Reminder> insert(Reminder reminder) async {
    reminder.id = await db.insert("Reminder", reminder.toMap());
    return reminder;
  }

  Future<Reminder> getReminder(String title) async {
    List<Map<String, Object?>> maps = await db.query("Reminder",
        columns: ["_id", "title", "date", "difficulty"],
        where: 'title = ?',
        whereArgs: [title]);
    return Reminder.fromMap(maps.first);
  }

  Future<List<Reminder>> getAll() async {
    List<Map<String, Object?>> maps = await db.query("Reminder",
        columns: ["_id", "title", "date", "difficulty"]);
    return maps.map((e) => Reminder.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    return await db.delete("Reminder", where: '_id = ?', whereArgs: [id]);
  }

  Future<int> update(Reminder reminder) async {
    return await db.update(
        "Reminder",
        reminder.toMap(),
        where: '_id = ?',
        whereArgs: [reminder.id]
    );
  }

  Future close() async => db.close();
  
  static void showError(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Es ist ein Fehler mit der Datenbank aufgetreten!")
    ));
  }
}