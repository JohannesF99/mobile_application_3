import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_application_3/screen/HomeScreen.dart';
import 'package:mobile_application_3/screen/WelcomeScreen.dart';
import 'package:mobile_application_3/util/SharedPrefs.dart';
import 'localization/L10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isFirst = await SharedPrefs.getBool("firstRun") ?? true;
  runApp(MyApp(isFirst: isFirst));
  SharedPrefs.saveBool("firstRun", false);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isFirst});
  final bool isFirst;

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
      home: widget.isFirst ? const WelcomeScreen() : HomeScreen(
        onLocalChange: (localFromHomescreen){
          setState(() {
            _locale = localFromHomescreen;
          });
        },
      ),
    );
  }
}