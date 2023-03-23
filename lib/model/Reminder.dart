import '../enum/Difficulty.dart';

/// Daten-Klasse, welche Informationen für einen Termin beinhaltet.
/// Ein Termin besteht aus einer ID, einem Titel, einem Datum und einer Schwierigkeit.
class Reminder{
  int? id;
  final String title;
  final DateTime date;
  final Difficulty difficulty;

  Reminder({
    this.id,
    required this.title,
    required this.date,
    required this.difficulty,
  });

  /// Methode für die Speicherung in der Datenbank.
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "title": title,
      "date": date.toIso8601String(),
      "difficulty": difficulty.name,
    };
    if (id != null) {
      map["_id"] = id;
    }
    return map;
  }

  /// Methode, um Objekt aus Datenbank zu instanzinieren.
  Reminder.fromMap(Map<String, Object?> map):
    id = map["_id"] as int,
    title = map["title"] as String,
    date = DateTime.parse(map["date"] as String),
    difficulty = Difficulty.values.byName(map["difficulty"] as String);
}