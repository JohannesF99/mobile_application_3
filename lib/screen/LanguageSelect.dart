import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_application_3/util/SharedPrefs.dart';

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
          title: Text(AppLocalizations.of(context)!.languages),
          backgroundColor: const Color(0xFF1E202C),
        ),
        body: FutureBuilder(
          future: SharedPrefs.getString("language"),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              var language = snapshot.data ?? "en";
              return Center(
                  child: ListView(
                    children: [
                      RadioListTile(
                        value: "en",
                        groupValue: language,
                        title: const Text("English",
                          style: TextStyle(
                              fontSize: 30
                          ),
                        ),
                        onChanged: (value){
                          setState(() {
                            language = value!;
                            Navigator.pop(context, 'en');
                          });
                        },
                      ),
                      RadioListTile(
                        value: "de",
                        groupValue: language,
                        title: const Text("Deutsch",
                          style: TextStyle(
                              fontSize: 30
                          ),
                        ),
                        onChanged: (value){
                          setState(() {
                            language = value!;
                            Navigator.pop(context, 'de');
                          });
                          //Navigator.pop(context, 'de');
                        },
                      ),
                      RadioListTile(
                        value: "es",
                        groupValue: language,
                        title: const Text("español",
                          style: TextStyle(
                              fontSize: 30
                          ),
                        ),
                        onChanged: (value){
                          setState(() {
                            language = value!;
                            Navigator.pop(context, 'es');
                          });
                        },
                      ),
                    ],
                  )
              );
            }
            return const Center(child: CircularProgressIndicator());
          }
        )
    );
  }
}