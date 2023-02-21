extension DT on DateTime {
  String toReadable(){
    return "am $day.$month.$year, um $hour:$minute Uhr";
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