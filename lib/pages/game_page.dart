import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:snake_game/pages/signin_page.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blank_pixel.dart';
import 'food_pixel.dart';
import 'snake_pixel.dart';

class SnakeGamePage extends StatefulWidget {
  
  final bool soundOn;
  final bool vibrationOn;

  const SnakeGamePage({Key? key, required this.soundOn, required this.vibrationOn}) : super(key: key);
  @override
  _SnakeGamePageState createState() => _SnakeGamePageState();
}

enum snakeDirection { UP, DOWN, LEFT, RIGHT }

class _SnakeGamePageState extends State<SnakeGamePage> {
  //grid dimensions
  int rowSize = 20;
  int totalSquares = 400;

  bool gameHasStarted = false;
  bool gamePaused = false;
  //late Timer _timer;

  //snake initial position
  List<int> snakePos = [0, 1, 2];

  //snake initial direction
  var currentDirection = snakeDirection.RIGHT;

  //food position
  int foodPos = 55;
  int currentScore = 0;
  static int highScore = 0;

  late bool _soundOn;
  late bool _vibrationOn;

  @override
  void initState() {
    super.initState();
    _soundOn = widget.soundOn;
    _vibrationOn = widget.vibrationOn;
    _loadHighScore(); // Load high score when the page is initialized
  }

  // Define an AudioPlayer object
  final _audioPlayer = AudioPlayer();

  // Function to play the sound
  Future<void> _playSound(String soundPath) async {
    if (_soundOn) {
      await _audioPlayer.play(AssetSource(soundPath));
    }
  }

  // Load high score from shared preferences
  void _loadHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  // Save high score to shared preferences
  void _saveHighScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('highScore', score);
  }

  //start game
  void startGame(BuildContext context) {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (!gamePaused) {
        setState(() {
          //keep the snake moving!
          moveSnake();

          //check if game is over
          if (gameOver()) {
            timer.cancel();
            _playSound('gameover.wav');
            if (highScore < currentScore) {
              highScore = currentScore;
              _saveHighScore(highScore);
            }
            if (_vibrationOn) {
              Vibration.vibrate(duration: 500);
            }
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: AlertDialog(
                        title: const Text('Game over'),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Your score is: $currentScore'),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    submitScore();
                                    newGame();
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                                  ),
                                  child: Text('Play Again'),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: (){
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context)=>SignInPage()),
                                  );
                                },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.red),
                                  ),
                                  child: Text('Exit'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        });
      }
    });
  }

  void submitScore() {
    //add data to firebase
  }

  void newGame() {
    setState(() {
      snakePos = [0, 1, 2];
      foodPos = 55;
      currentDirection = snakeDirection.RIGHT;
      gameHasStarted = false;
      currentScore = 0;
    });
  }

  void eatFood() {
    _playSound('food.wav');
    currentScore++;
    //make sure food is not where snake is
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalSquares);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case snakeDirection.RIGHT:
        {
            //add a head
            //if snake is at right wall,need to re-adjust
            if(snakePos.last%rowSize==0){
                snakePos.add(snakePos.last+1-rowSize);
            }else{
                snakePos.add(snakePos.last+1);
            }      
        }
        break;

      case snakeDirection.LEFT:
        {
          //add a head
          //if snake is at right wall,need to re-adjust
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }
        break;

      case snakeDirection.UP:
        {
          //add a head
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;

      case snakeDirection.DOWN:
        {
          //add a head
          if (snakePos.last + rowSize > totalSquares) {
            snakePos.add(snakePos.last + rowSize - totalSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;

      default:
    }
    // snake is eating food
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      // remove tail
      snakePos.removeAt(0);
    }
  }

  //game over
  bool gameOver() {
    //the game is over when the snake runs into itself
    //this occur when there is a duplicate position in snakePos list
    //this list is the body of the snake (no head)
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);
    if (bodySnake.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 173, 235, 101),
      body: Column(
        children: [
          //highscore
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //user current score
                    Text('Current Score'),
                    Text(
                      currentScore.toString(),
                      style: TextStyle(
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
                Text('highscore:'),
                Text(
                  highScore.toString(),
                  style: TextStyle(fontSize: 36),
                ),
              ],
            ),
          ),

          //gamegrid
          Expanded(
            flex: 3,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 && currentDirection != snakeDirection.UP) {
                  currentDirection = snakeDirection.DOWN;
                } else if (details.delta.dy < 0 && currentDirection != snakeDirection.DOWN) {
                  currentDirection = snakeDirection.UP;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 && currentDirection != snakeDirection.LEFT) {
                  currentDirection = snakeDirection.RIGHT;
                } else if (details.delta.dx < 0 && currentDirection != snakeDirection.RIGHT) {
                  currentDirection = snakeDirection.LEFT;
                }
              },
              child: GridView.builder(
                itemCount: totalSquares,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: rowSize),
                itemBuilder: (context, index) {
                  if (snakePos.contains(index)) {
                    return const SnakePixel();
                  } else if (foodPos == index) {
                    return const FoodPixel();
                  } else {
                    return const BlankPixel();
                  }
                },
              ),
            ),
          ),

          //play button
          Expanded(
            child: Center(
              child: MaterialButton(
                color: gameHasStarted ? Colors.grey : Colors.green,
                onPressed: gameHasStarted
                    ? () {
                        setState(() {
                          gamePaused = !gamePaused;
                        });
                      }
                    : () => startGame(context),
                child: Text(
                  gamePaused ? 'PLAY' : (gameHasStarted ? 'PAUSE' : 'START'),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
