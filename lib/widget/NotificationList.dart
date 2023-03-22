import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mobile_application_3/model/NotificationDetail.dart';
import 'package:mobile_application_3/util/DateTimeUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../util/Notifier.dart';

/// Erstellt ein Widget, welches alle eingestellten Erinnerungen anzeigt.
/// Bekommt einen Channel-Namen übergeben, welcher den Namen eines Termins
/// wiederspiegelt.
class NotificationList extends StatefulWidget {
  const NotificationList({
    super.key,
    required this.channel,
  });

  final String channel;

  @override
  State<StatefulWidget> createState() => _NotificationList();
}

class _NotificationList extends State<NotificationList> {

  /// Mit dem FutureBuilder wird eine Liste von Benachrichtigungen generiert,
  /// daher das [late]-Keyword.
  late List<NotificationDetail> notifications;

  @override
  void initState() {
    /// Wenn eine Benachrichtigung ausläuft, soll der korrespondierende
    /// Eintrag in der Liste gelöscht werden.
    /// Dazu muss die [onNotificationDisplayedMethod] die
    /// Methode [setState] aufrufen, damit der FutureBuilder erneut gebaut wird.
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (_) async {},
      onNotificationDisplayedMethod: (_) async => setState((){})
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// FutureBuilder für das asynchrone Erhalten.
    return FutureBuilder(
      future: Notifier.getForChannel(widget.channel),
      builder: (BuildContext context, AsyncSnapshot<List<NotificationDetail>> snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          notifications = snapshot.data!;
          /// Sobald die Daten erhalten wurde, verwende einen [ListView.builder],
          /// um über die Liste zu iterieren und die Benachrichtigungen
          /// anzuzeigen
          return ListView.builder(
            /// Liste soll nicht Scrollbar sein.
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (BuildContext context, int i) {
              return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width/10
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height/15,
                    child: Card(
                      color: const Color(0xFF1E202C),
                      elevation: 5,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Divider(indent: 20, color: Colors.transparent),
                              Text(notifications[i].date.toReadable(time: false, am: AppLocalizations.of(context)?.on),
                                style: const TextStyle(fontSize: 16)
                              ),
                              const Divider(indent: 10, color: Colors.transparent),
                              Text("${AppLocalizations.of(context)!.still} ${notifications[i].date.difference(DateTime.now()).inDays} ${AppLocalizations.of(context)!.day_s}",
                                  style: const TextStyle(fontSize: 16)
                              ),
                              const Spacer(),
                              IconButton(
                                /// Wenn die Benachrichtigung abgeschaltet
                                /// werden soll, Cancel sie und rufe [setState]
                                /// auf, um die Liste zu aktualisieren.
                                  onPressed: () =>
                                      AwesomeNotifications()
                                          .cancel(notifications[i].id)
                                          .whenComplete(() => setState((){})),
                                  icon: const Icon(Icons.delete_forever, size: 35,)
                              ),
                              const Divider(indent: 20, color: Colors.transparent),
                            ]
                        ),
                      ),
                    ),
                  )
              );
            },
          );
        }
        /// Solange die Daten noch nicht erhalten sind, soll ein
        /// [CircularProgressIndicator] angezeigt werden.
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}