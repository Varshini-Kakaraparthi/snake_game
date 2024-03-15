import 'package:flutter/material.dart';
import 'package:snake_game/pages/home_page.dart';
import 'package:snake_game/pages/signin_page.dart';
import 'package:snake_game/pages/signup_page.dart';

void main() {
  runApp(SnakeGame());
}

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnakeGame',
      theme: ThemeData(
        // Define your app's theme here
      ),
      initialRoute: '/signin', // Specify initial route
      routes: {
        '/signin': (context) => SignInPage(), // Route for the sign-in page
        '/signup': (context) => SignupPage(), // Route for the sign-up page
        '/home': (context) => HomePage(), // Route for the home page
      },
    );
  }
}
