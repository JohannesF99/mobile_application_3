import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:mobile_application_3/util/DateTimeUtil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CountDownUtil{
  static CountdownTimer inGerman(DateTime date){
    return CountdownTimer(
      endTime: date.getRemainingMilliSeconds(),
      widgetBuilder: (BuildContext context, time) {
        if (time == null) {
          return Center(
            child: Text(AppLocalizations.of(context).the_countdown_has_expired,
              style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.5
              ),
            ),
          );
        }
        String value = '';
        if (time.days != null) {
          var days = time.days!;
          value = '$value$days ${AppLocalizations.of(context).day_s_and} ';
        }
        var hours = (time.hours ?? 0).getNumberAddZero();
        value = '$value$hours:';
        var min = (time.min ?? 0).getNumberAddZero();
        value = '$value$min:';
        var sec = (time.sec ?? 0).getNumberAddZero();
        value = '$value$sec ${AppLocalizations.of(context).remaining}';
        return Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.5
          ),
        );
      },
    );
  }
}