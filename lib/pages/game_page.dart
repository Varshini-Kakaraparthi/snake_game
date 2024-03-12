import 'dart:async';
import 'dart:math';
import 'blank_pixel.dart';
import 'food_pixel.dart';
import 'snake_pixel.dart';

import 'package:flutter/material.dart';


class SnakeGamePage extends StatefulWidget {

  @override
  _SnakeGamePageState createState() => _SnakeGamePageState();
}

enum snake_Direction{UP,DOWN,LEFT,RIGHT}

class _SnakeGamePageState extends State<SnakeGamePage> {
  //grid dimensions
  int rowSize = 10;
  int totalSquares=100;

  bool gameHasStarted=false;

  //snake initial position
  List<int> snakePos=[0,1,2];

  //snake initial direction
  var currentDirection=snake_Direction.RIGHT;

  //food position
  int foodPos=55;
  int currentScore=0;

  //start game
  void startGame() {
    gameHasStarted=true;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState((){
        //keep the snake moving!
        moveSnake();
        //check if game is over
        if (gameOver()){
          timer.cancel();
          showDialog(
            context:context,
            barrierDismissible: false,
            builder:(context){
              return AlertDialog(
                title:const Text('Game over'),
                content:Column(
                  children: [
                    Text('Your score is: $currentScore'),
                    const TextField(
                      decoration: InputDecoration(hintText:'Enter name:'),
                    ),
                  ],
                ),
                actions:[
                  MaterialButton(
                    onPressed: (){
                      submitScore();
                      newGame();
                      Navigator.pop(context);
                    },
                    child:Text('Submit'),
                    color:Colors.pink,
                    ),
                  ],
                );
              },
            );
          };
      });
    });
  }

  void submitScore(){
    //add data to firebase
  }

  void newGame(){
    setState((){
      snakePos=[0,1,2];
      foodPos=55;
      currentDirection=snake_Direction.RIGHT;
      gameHasStarted=false;
      currentScore=0;
    });
  }

  void eatFood(){
    currentScore++;
    //make sure food is not where snake is
    while(snakePos.contains(foodPos)){
      foodPos=Random().nextInt(totalSquares);
    }
  }

  void moveSnake(){
    switch (currentDirection){
        case snake_Direction.RIGHT:
        {
            //add a head
            //if snake is at right wall,need to re-adjust
            if(snakePos.last%rowSize==9){
                snakePos.add(snakePos.last+1-rowSize);
            }else{
                snakePos.add(snakePos.last+1);
            }      
        }
        break;

        case snake_Direction.LEFT:
        {
             //add a head
            //if snake is at right wall,need to re-adjust
            if(snakePos.last%rowSize==0){
                snakePos.add(snakePos.last-1+rowSize);
            }else{
                snakePos.add(snakePos.last-1);
            } 
        }
        break;

        case snake_Direction.UP:
        {
             //add a head
         
            if(snakePos.last<rowSize){
                snakePos.add(snakePos.last-rowSize+totalSquares);
            }else{
                snakePos.add(snakePos.last-rowSize);
            } 
        }
        break;

        case snake_Direction.DOWN:
        {
             //add a head
             if(snakePos.last+rowSize > totalSquares){
                snakePos.add(snakePos.last+rowSize-totalSquares);
            }else{
                snakePos.add(snakePos.last+rowSize);
            } 
        }
        break;

        default:
    }
    // snake is eating food
    if(snakePos.last==foodPos){
        eatFood();
    }else{
        // remove tail
        snakePos.removeAt(0);
    }
  }
  
  //game over
  bool gameOver(){
    //the game is over when the snake runs into itself
    //this occur when there is a duplicate position in snakePos list
    //this list is the body of the snale(no head)
    List<int> bodySnake=snakePos.sublist(0,snakePos.length-1);
    if(bodySnake.contains(snakePos.last)){
        return true;
    }
    return false;

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:Column(
        children: [
          //highscore
          Expanded(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //user current score
                    Text('Current Score'),
                    Text(
                      currentScore.toString(),
                      style:TextStyle(fontSize: 36),
                    ),
                  ],
                ),

                Text('highscores..')
              ],
            ) ,
          ),
          //gamegrid
          Expanded(
            flex:3,
            child:GestureDetector(
              onVerticalDragUpdate:(details){
                if(details.delta.dy>0 && currentDirection!=snake_Direction.UP){
                  currentDirection=snake_Direction.DOWN;
                }else if(details.delta.dy<0 && currentDirection!=snake_Direction.DOWN){
                  currentDirection=snake_Direction.UP;
                }
              } ,
              onHorizontalDragUpdate: (details){
                if(details.delta.dx>0 && currentDirection!=snake_Direction.LEFT){
                  currentDirection=snake_Direction.RIGHT;
                }else if(details.delta.dx<0 && currentDirection!=snake_Direction.RIGHT){
                  currentDirection=snake_Direction.LEFT;
                }
              },
              child: GridView.builder(
                itemCount:totalSquares,
                physics:const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:rowSize),
                itemBuilder: (context,index){
                  if(snakePos.contains(index)){
                    return const SnakePixel();
                  }else if(foodPos==index){
                    return const FoodPixel();
                  }
                  else{
                    return const BlankPixel();
                  }
                }),
              ),
            ),
            
            //play button
            Expanded(
              child:Container(
                child:Center(
                  child:MaterialButton(
                    child:Text('PLAY'),
                    color:gameHasStarted?Colors.grey:Colors.green,
                    onPressed:gameHasStarted?(){}:startGame ,
                    ) ,
                  ) ,
                ) ,
              ),
            ],
          ),
      );
    }
}