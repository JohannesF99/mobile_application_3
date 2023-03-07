import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_application_3/database/NoteDB.dart';
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

  await AwesomeNotifications().requestPermissionToSendNotifications(
    permissions: [
      NotificationPermission.PreciseAlarms,
      NotificationPermission.Sound,
      NotificationPermission.Vibration,
      NotificationPermission.Alert,
      NotificationPermission.Badge,
      NotificationPermission.FullScreenIntent,
      NotificationPermission.Light,
    ]
  );
  final isFirst = await SharedPrefs.getBool("firstRun") ?? true;
  await ReminderDB().open();
  await NoteDB().open();
  final language = await SharedPrefs.getString("language") ?? "en";
  runApp(MyApp(isFirst: true, language: language));
  SharedPrefs.saveBool("firstRun", false);
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.isFirst,
    required this.language
  });

  final bool isFirst;
  final String language;

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {

  late Locale _locale;

  @override
  void initState() {
    _locale = Locale(widget.language);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Application 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      locale: _locale,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: widget.isFirst ? WelcomeScreen(
        onLocalChange: (localFromHomescreen){
          setState(() {
            _locale = localFromHomescreen;
            SharedPrefs.saveString("language", localFromHomescreen.toString());
          });
        },
      ) : HomeScreen(
        onLocalChange: (localFromHomescreen){
          setState(() {
            _locale = localFromHomescreen;
            SharedPrefs.saveString("language", localFromHomescreen.toString());
          });
        },
      ),
    );
  }
}