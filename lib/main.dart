import 'package:flutter/material.dart';
import 'package:snake_game/pages/signin_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(snakegame());
}

class snakegame extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
}