import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application_3/screen/HomeScreen.dart';
import 'package:mobile_application_3/screen/WelcomeScreen.dart';
import 'package:mobile_application_3/util/SharedPrefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Colors.black,
            ledColor: Colors.white
        )
      ],
      debug: true
  );
  final isFirst = await SharedPrefs.getBool("firstRun") ?? true;
  runApp(MyApp(isFirst: isFirst));
  SharedPrefs.saveBool("firstRun", false);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isFirst});

  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Application 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: isFirst ? const WelcomeScreen() : const HomeScreen(),
    );
  }
}