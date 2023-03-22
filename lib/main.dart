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
  /// Geht sicher, dass z.B.: auf SharedPrefs zugegriffen werden kann,
  /// bevor die App komplett initialisiert ist.
  WidgetsFlutterBinding.ensureInitialized();
  /// Initialisiert die Benachrichtigungen.
  /// Das Plugin benötigt dabei immer min. einen default Channel
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
  /// Beantrage Benachrichtigungen, welche vom System aktzeptiert werden müssen
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
  /// Check, ob die App das Erste mal ausgeführt wird.
  /// Falls ja, wird der Willkommens-Screen angezeigt, anschließend
  /// nie wieder.
  final isFirst = await SharedPrefs.getBool("firstRun") ?? true;
  /// Initialisiert Datenbank für Termine
  await ReminderDB().open();
  /// Initialisiert Datenbank für Notizen
  await NoteDB().open();
  /// Fragt nach der eingestellten Sprache.
  /// Sollte keine Sprache eingestellt sein, ist der Fallback Englisch
  final language = await SharedPrefs.getString("language") ?? "en";
  runApp(MyApp(isFirst: isFirst, language: language));
  SharedPrefs.saveBool("firstRun", false);
}

/// Standard root-Widget der App
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
      /// Wenn es der erste Start der App ist, dann zeige den Welcome-Screen,
      /// ansonsten den normalen Homescreen
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