import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Drawer(

        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.yellow,
              ),
              child: Text("Einstellungen"),
            ),
            ListTile(
              leading: Icon(
                Icons.language,
              ),
              title: const Text('Sprache'),
              onTap: (){
                Navigator.pop(context);
              }
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Mobile Application 3"),

        backgroundColor: Colors.black,
      ),
    );
  }
}