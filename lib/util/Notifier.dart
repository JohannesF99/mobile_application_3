import 'package:awesome_notifications/awesome_notifications.dart';

import '../model/Reminder.dart';

class Notifier{
  static create(Reminder rem) {
    AwesomeNotifications().setChannel(NotificationChannel(
        channelKey: rem.title,
        channelName: rem.title,
        channelDescription: rem.title
    ));
    [1, 7, 14]
        .map((e) => rem.date.subtract(Duration(days: e)))
        .forEach((e) async => AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: e.hashCode,
            channelKey: rem.title,
            wakeUpScreen: true,
            title: "Klausur ${rem.title}!",
            body: "Lernen!"
        ),
        schedule: NotificationCalendar.fromDate(date: e)
    ));
  }

  static delete(Reminder rem) {
    AwesomeNotifications().cancelNotificationsByChannelKey(rem.title);
    AwesomeNotifications().removeChannel(rem.title);
  }
}