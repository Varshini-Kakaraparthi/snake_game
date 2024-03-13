import 'package:flutter/material.dart';
import 'package:snake_game/pages/game_page.dart';
import 'package:snake_game/pages/signin_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20.0),
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
                // Implement signup logic here
                // For simplicity, let's just navigate to the game screen after signup
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SnakeGamePage()),
                );
              },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              child: Text('Back to Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
