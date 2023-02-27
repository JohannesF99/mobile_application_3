import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mobile_application_3/model/NotificationDetail.dart';
import 'package:mobile_application_3/util/DateTimeUtil.dart';
import 'package:flutter/material.dart';

import '../util/Notifier.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({
    super.key,
    required this.channel,
  });

  final String channel;

  @override
  State<StatefulWidget> createState() => _NotificationList();
}

Future<void> onAction(a) async {}

class _NotificationList extends State<NotificationList> {

  late List<NotificationDetail> notifications;

  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (_) async {},
      onNotificationDisplayedMethod: (_) async => setState((){})
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Notifier.getForChannel(widget.channel),
      builder: (BuildContext context, AsyncSnapshot<List<NotificationDetail>> snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          notifications = snapshot.data!;
          return ListView.builder(
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
                      child: Center(
                        child: Row(
                            children: [
                              const Divider(indent: 20, color: Colors.transparent),
                              Text(notifications[i].date.toReadable(time: false)),
                              const Divider(indent: 10, color: Colors.transparent),
                              Text("noch ${notifications[i].date.difference(DateTime.now()).inDays} Tag(e)"),
                              const Spacer(),
                              IconButton(
                                  onPressed: () =>
                                      AwesomeNotifications()
                                          .cancel(notifications[i].id)
                                          .whenComplete(() => setState((){})),
                                  icon: const Icon(Icons.delete_forever)
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}