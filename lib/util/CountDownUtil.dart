import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:mobile_application_3/util/DateTimeUtil.dart';

class CountDownUtil{
  static CountdownTimer inGerman(DateTime date){
    return CountdownTimer(
      endTime: date.getRemainingMilliSeconds(),
      widgetBuilder: (BuildContext context, time) {
        if (time == null) {
          return const Center(
            child: Text("Der Countdown ist abgelaufen!"),
          );
        }
        String value = '';
        if (time.days != null) {
          var days = time.days!;
          value = '$value$days Tag(e) und ';
        }
        var hours = (time.hours ?? 0).getNumberAddZero();
        value = '$value$hours:';
        var min = (time.min ?? 0).getNumberAddZero();
        value = '$value$min:';
        var sec = (time.sec ?? 0).getNumberAddZero();
        value = '$value$sec verbleibend!';
        return Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),
        );
      },
    );
  }
}