import 'package:flutter/material.dart';
import 'package:mobile_application_3/enum/Difficulty.dart';

class DifficultyUtil{
  /// Gibt die Farben für die Schwierigkeiten zurück.
  static Color getColor(Difficulty difficulty) {
    switch(difficulty){
      case Difficulty.easy: return Colors.green;
      case Difficulty.moderate: return Colors.yellow;
      case Difficulty.difficult: return Colors.red;
    }
  }
}