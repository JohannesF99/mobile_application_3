import 'package:flutter/material.dart';
import 'package:mobile_application_3/enum/Difficulty.dart';

import '../util/DifficultyUtil.dart';

/// Custom-Widget, welches einen runden, farbigen Kreis darstellt.
/// Bekommt eine [difficulty], welche die Farbe festlegt, die dargestellt wird.
class DifficultyCircle extends StatelessWidget{
  const DifficultyCircle({super.key, required this.difficulty});

  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      /// BorderRadius 50 = Kreis
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 40,
        width: 40,
        /// Funktion gibt Farbe basierend auf der Schwierigkeit zurück.
        color: DifficultyUtil.getColor(difficulty),
      ),
    );
  }
}