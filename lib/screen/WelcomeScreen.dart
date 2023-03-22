import 'package:flutter/material.dart';
import 'package:mobile_application_3/screen/HomeScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.onLocalChange});

  final void Function(Locale locale) onLocalChange;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E202C),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Divider(height: 70, color: Colors.transparent),
            Text(
              AppLocalizations.of(context).welcome_to_Exam_Reminder,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
            const Spacer(),
            Text(AppLocalizations.of(context).welcome_description,
              style: const TextStyle(fontSize: 22),
            ),
            const Spacer(),
              Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  elevation: 5,
                  color: const Color(0xFF1E202C),
                  child: SizedBox(
                    width: 350,
                      child: TextButton(
                        child: Text(AppLocalizations.of(context).lets_get_started,
                          style: const TextStyle(fontSize: 26),
                        ),
                        onPressed: () => Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => HomeScreen(
                                onLocalChange: widget.onLocalChange
                            )),
                        ),
                  ),
                  ),
                ),
              ),
            const Divider(height: 50, color: Colors.transparent),
          ],
        )
      ),
    );
  }
}