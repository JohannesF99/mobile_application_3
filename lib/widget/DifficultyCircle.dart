import 'package:flutter/material.dart';
import 'package:mobile_application_3/enum/Difficulty.dart';

import '../util/DifficultyUtil.dart';

class DifficultyCircle extends StatelessWidget{
  const DifficultyCircle({super.key, required this.difficulty});

  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 20,
        width: 20,
        color: DifficultyUtil.getColor(difficulty),
      ),
    );
  }
}