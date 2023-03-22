/// Daten-Klasse um Informationen für eine Notiz zu speichern.
/// Jede Notiz hat einen zugehörigen Termin, einen Titel und eine Inhalt(Body).
class Note{
  int? id;
  int? reminderId;
  final String title;
  final String body;

  Note({
    this.id,
    this.reminderId,
    required this.title,
    required this.body,
  });

  Note setReminderId(int value) {
    reminderId = value;
    return this;
  }

  /// Methode für die Speicherung in der Datenbank.
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "reminderId": reminderId,
      "title": title,
      "body": body,
    };
    if (id != null) {
      map["_id"] = id;
    }
    return map;
  }

  /// Methode, um Objekt aus Datenbank zu instanzinieren.
  Note.fromMap(Map<String, Object?> map):
    id = map["_id"] as int,
    reminderId = map["reminderId"] as int,
    title = map["title"] as String,
    body = map["body"] as String;
}