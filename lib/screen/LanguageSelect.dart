import 'package:flutter/material.dart';

class LanguageSelectScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LanguageSelectScreen();
}

class _LanguageSelectScreen extends State<LanguageSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Sprachen"),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pop(context, 'en');
                },
                child: const Text("English",
                  style: TextStyle(fontSize: 24),
              ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context, 'de');
                },
                child: const Text("Deutsch",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        )
    );
  }
}