class Reminder{
  int? id;
  final String title;
  final DateTime date;

  Reminder({
    this.id,
    required this.title,
    required this.date,
  });

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "title": title,
      "date": date.toIso8601String(),
    };
    if (id != null) {
      map["_id"] = id;
    }
    return map;
  }

  Reminder.fromMap(Map<String, Object?> map):
    id = map["_id"] as int,
    title = map["title"] as String,
    date = DateTime.parse(map["date"] as String);
}