import 'package:flutter/material.dart';
import 'package:mobile_application_3/database/ReminderDB.dart';
import 'package:mobile_application_3/screen/HomeScreen.dart';
import 'package:mobile_application_3/screen/WelcomeScreen.dart';
import 'package:mobile_application_3/util/SharedPrefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isFirst = await SharedPrefs.getBool("firstRun") ?? true;
  final db = ReminderDB();
  await db.open();
  runApp(MyApp(isFirst: isFirst, db: db));
  SharedPrefs.saveBool("firstRun", false);
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.isFirst,
    required this.db
  });

  final bool isFirst;
  final ReminderDB db;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Application 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: isFirst ? WelcomeScreen(db: db) : HomeScreen(db: db),
    );
  }
}