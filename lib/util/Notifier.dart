import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mobile_application_3/model/NotificationDetail.dart';

import '../model/Reminder.dart';

/// Wrapper-Klasse für die API des [AwesomeNotifications]-PlugIns.
class Notifier{
  /// Erstellt neue Benachrichtigungen auf Basis eines Termins.
  static void create(Reminder rem) {
    /// Benachrichtigungen werden auf Basis von Kanälen erstellt.
    /// Daher wird für jeden Termin ein Kanal erstellt.
    AwesomeNotifications().setChannel(NotificationChannel(
        channelKey: rem.title,
        channelName: rem.title,
        channelDescription: rem.title
    ));
    /// Anschließend werden 3 Termin eingestellt.
    /// Aktuell in der Spanne von 5, 15 & 25 Sekunden vor dem Termin.
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

  /// Löscht die Benachrichtigungen für einen Termin und anschließend den Kanal
  static void delete(Reminder rem) {
    AwesomeNotifications().cancelNotificationsByChannelKey(rem.title);
    AwesomeNotifications().removeChannel(rem.title);
  }

  /// Gibt alle Benachrichtigungen für einen Termin wieder.
  static Future<List<NotificationDetail>> getForChannel(String key) async {
    final notifications = (await AwesomeNotifications()
        /// Erhalte alle Benachrichtigungen
        .listScheduledNotifications())
        /// Filter nur diejenigen, die mit dem Termin übereinstimmen
        .where((e) => e.content!.channelKey == key)
        /// Erstelle aus jeder Benachrichtigung ein [NotificationDetail]-Objekt.
        .map((e) {
          final schedule = e.schedule as NotificationCalendar;
          final date = DateTime(schedule.year!, schedule.month!, schedule.day!);
          return NotificationDetail(id: e.content!.id!, date: date);
        })
        .toList();
    /// Sortiert die Benachrichtigungen nach dem Datum
    notifications.sort((a,b) => a.date.compareTo(b.date));
    return notifications;
  }
}