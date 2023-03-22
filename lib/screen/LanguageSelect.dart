import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_application_3/util/SharedPrefs.dart';

/// Bildschirm, um die Sprache auszuwählen
class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LanguageSelectScreen();
}

class _LanguageSelectScreen extends State<LanguageSelectScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF1E202C),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).languages),
          backgroundColor: const Color(0xFF1E202C),
        ),
        /// Holt sich asynchron die Sprache aus den Shared Preferences
        body: FutureBuilder(
          future: SharedPrefs.getString("language"),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              var language = snapshot.data ?? "en";
              return Center(
                  child:
                  ListView.builder(
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                        value: index == 0 ? "en" : index == 1 ? "de" : "es",
                        groupValue: language,
                        title:  index == 0 ? const Text("English", style: TextStyle(fontSize: 30)) :
                                index == 1 ? const Text("Deutsch", style: TextStyle(fontSize: 30)) :
                                const Text("español", style: TextStyle(fontSize: 30)),
                        onChanged: (value) {
                          setState(() {
                            language = value!;
                            Navigator.pop(context, value);
                          });
                        },
                      );
                    },
                  )
              );
            }
            return const Center(child: CircularProgressIndicator());
          }
        )
    );
  }
}