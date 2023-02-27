import 'package:flutter/material.dart';
import 'package:mobile_application_3/database/ReminderDB.dart';
import 'package:mobile_application_3/screen/HomeScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.db});

  final ReminderDB db;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const Divider(height: 50, color: Colors.transparent),
          const Text(
              "Willkommen bei Klausur-Reminder",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
          ),
          const Spacer(),
          Center(
            child: TextButton(
              child: const Text("Los geht's!"),
              onPressed: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => HomeScreen(
                    onLocalChange: (localFromHomescreen) {},
                    db: widget.db,
                  )),
              ),
            ),
          ),
          const Divider(height: 50, color: Colors.transparent),
        ],
      )
    );
  }
}