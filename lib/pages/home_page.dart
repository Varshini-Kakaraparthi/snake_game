import 'package:flutter/material.dart';
import 'package:snake_game/pages/game_page.dart';
import 'package:snake_game/pages/signin_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _soundOn = true;
  bool _vibrationOn = true;
  double _volume = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/snake.png',
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Play button action
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SnakeGamePage(
                      soundOn: _soundOn,
                      vibrationOn: _vibrationOn,
                    ),
                  ),
                );
              },
              child: Text(
                'Play',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context)=>SignInPage()),
                  );
                },
              child: Text(
                'Exit',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sound:'),
                Switch(
                  value: _soundOn,
                  onChanged: (value) {
                    setState(() {
                      _soundOn = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Vibration:'),
                Switch(
                  value: _vibrationOn,
                  onChanged: (value) {
                    setState(() {
                      _vibrationOn = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Volume Level', style: TextStyle(fontSize: 16)),
            Container(
              width: MediaQuery.of(context).size.width * 3 / 4,
              child: Slider(
                value: _volume,
                onChanged: (newValue) {
                  setState(() {
                    _volume = newValue;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
