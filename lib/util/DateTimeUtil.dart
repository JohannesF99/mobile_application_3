/// Erweiterungsfunktionen für die Klasse [DateTime]
extension DT on DateTime {
  /// Gibt das Datum in einem für Menschen einfach lesbaren Format zuück.
  String toReadable({required bool time, String? am, String? um, String? stunde}){
    var output = "$am ${day.getNumberAddZero()}.${month.getNumberAddZero()}."
        "${year.getNumberAddZero()}";
    return !time ? output : "$output, $um ${hour.getNumberAddZero()}:"
        "${minute.getNumberAddZero()} $stunde";
  }

  /// Gibt die Millisekunden bis zum Datum zurück.
  int getRemainingMilliSeconds() {
    return millisecondsSinceEpoch;
  }
}

extension AddZero on int {
  /// Fügt eine führende "0" zu einstelligen Monaten/Tagen hinzu.
  /// Beispiel: 5.7.2023 -> 05.07.2023
  String getNumberAddZero() {
    if (this < 10) {
      return "0$this";
    }
    return toString();
  }
}