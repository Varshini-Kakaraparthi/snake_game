import 'package:flutter/material.dart';
import 'package:snake_game/pages/game_page.dart';
import 'package:snake_game/pages/signup_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(),
        '/signup': (context) => SignupPage(),
        '/game': (context) => SnakeGamePage(),
      },
    );
  }
}

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Implement sign-in logic here
                // For simplicity, let's just navigate to the game screen
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SnakeGamePage()),
                );
              },
              child: Text('Sign In'),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: Text('Create an Account'),
            ),
          ],
        ),
      ),
    );
  }
}


