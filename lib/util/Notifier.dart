import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mobile_application_3/model/NotificationDetail.dart';

import '../model/Reminder.dart';

class Notifier{
  static void create(Reminder rem) {
    AwesomeNotifications().setChannel(NotificationChannel(
        channelKey: rem.title,
        channelName: rem.title,
        channelDescription: rem.title
    ));
    //TODO
    [5, 15, 25]
        .map((e) => rem.date.subtract(Duration(seconds: e)))
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

  static void delete(Reminder rem) {
    AwesomeNotifications().cancelNotificationsByChannelKey(rem.title);
    AwesomeNotifications().removeChannel(rem.title);
  }

  static Future<List<NotificationDetail>> getForChannel(String key) async {
    final notifications = (await AwesomeNotifications()
        .listScheduledNotifications())
        .where((e) => e.content!.channelKey == key)
        .map((e) {
          final schedule = e.schedule as NotificationCalendar;
          final date = DateTime(schedule.year!, schedule.month!, schedule.day!);
          return NotificationDetail(id: e.content!.id!, date: date);
        })
        .toList();
    notifications.sort((a,b) => a.date.compareTo(b.date));
    return notifications;
  }
}