import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_application_3/database/ReminderDB.dart';
import 'package:mobile_application_3/screen/HomeScreen.dart';
import 'package:mobile_application_3/screen/WelcomeScreen.dart';
import 'package:mobile_application_3/util/SharedPrefs.dart';
import 'localization/L10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'default',
            channelName: 'Default Notifications',
            channelDescription: 'Default Notification Channel for General Information',
            defaultColor: Colors.black,
            ledColor: Colors.white
        )
      ],
      debug: true
  );
  final isFirst = await SharedPrefs.getBool("firstRun") ?? true;
  final db = ReminderDB();
  await db.open();
  runApp(MyApp(isFirst: isFirst, db: db));
  SharedPrefs.saveBool("firstRun", false);
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.isFirst,
    required this.db
  });

  final bool isFirst;
  final ReminderDB db;

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp>{

  Locale _locale = Locale('en');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Application 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      locale: _locale,
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: widget.isFirst ? WelcomeScreen(db: db) : HomeScreen(
        db: db,
        onLocalChange: (localFromHomescreen){
          setState(() {
            _locale = localFromHomescreen;
          });
        },
      ),
    );
  }
}