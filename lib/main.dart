import 'package:flutter/material.dart';
import 'pages/game_page.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(snakegame());
}

class snakegame extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SnakeGamePage(),
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
}