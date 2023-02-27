extension DT on DateTime {
  String toReadable({required bool time}){
    var output = "am ${day.getNumberAddZero()}.${month.getNumberAddZero()}."
        "${year.getNumberAddZero()}";
    return !time ? output : "$output, um ${hour.getNumberAddZero()}:"
        "${minute.getNumberAddZero()} Uhr";
  }

  int getRemainingMilliSeconds() {
    return millisecondsSinceEpoch;
  }
}

extension AddZero on int {
  String getNumberAddZero() {
    if (this < 10) {
      return "0$this";
    }
    return toString();
  }
}