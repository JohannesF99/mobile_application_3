import '../enum/Difficulty.dart';

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

  Reminder.fromMap(Map<String, Object?> map):
    id = map["_id"] as int,
    title = map["title"] as String,
    date = DateTime.parse(map["date"] as String),
    difficulty = Difficulty.values.byName(map["difficulty"] as String);
}