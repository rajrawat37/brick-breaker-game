import 'dart:async';

import 'package:brick_breaker/brick.dart';
import 'package:brick_breaker/coverscreen.dart';
import 'package:brick_breaker/ball.dart';
import 'package:brick_breaker/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction { UP, DOWN }

class _HomePageState extends State<HomePage> {
  //ball variables

  double ballX = 0;
  double ballY = 0;
  var ballDirection = direction.DOWN;

  //player variables

  double playerX = 0;
  double playerWidth = 0.3; //out of 2

  //brick variables
  double brickX = 0;
  double brickY = -0.9;
  double brickWidth = 0.4; //out of 2
  double brickHeight = 0.1;
  bool brickBroken = false;
  //game settings

  bool hasGameStarted = false;
  bool isGameOver = false;

  void startGame() {
    hasGameStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      //update direction
      updateDirection();

      //move ball
      moveBall();

      //check if the player is dead
      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = false;
      }

      //check if brick is hit
      checkForBrokenBricks();
    });
  }

  void checkForBrokenBricks() {
    //checks for when ball hits the bottom of brick
    if (ballX >= brickX &&
        ballX <= brickX + brickWidth &&
        ballY >= brickY + brickHeight &&
        brickBroken == false) {
      brickBroken = true;
      ballDirection = direction.DOWN;
    }
  }

  //update direction
  void updateDirection() {
    setState(() {
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballDirection = direction.UP;
      } else if (ballY <= -0.9) {
        ballDirection = direction.DOWN;
      }
    });
  }

  bool isPlayerDead() {
    //player dies if ball reaches the bottom of screen
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

//move ball
  void moveBall() {
    if (ballDirection == direction.DOWN) {
      ballY += 0.01;
    } else if (ballDirection == direction.UP) {
      ballY -= 0.01;
    }
  }

//move player left
  void moveLeft() {
    setState(() {
      //only allow moving left if player does not move off the screen
      if (!(playerX - 0.2 < -1)) {
        playerX -= 0.2;
      }
    });
  }
//move player right

  void moveRight() {
    setState(() {
      //onyl allow moving right if player does not move off the screen
      if (!(playerX + playerWidth >= 1)) {
        playerX += 0.2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
            moveLeft();
          } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
            moveRight();
          }
        },
        child: GestureDetector(
          onTap: startGame,
          child: Scaffold(
            backgroundColor: Colors.deepOrange[100],
            body: Center(
              child: Stack(
                children: [
                  //TAP TO PLAY
                  CoverScreen(hasGameStarted: hasGameStarted),

                  //My Ball
                  MyBall(
                    ballX: ballX,
                    ballY: ballY,
                  ),

                  // player
                  MyPlayer(playerX: playerX, playerWidth: playerWidth),

                  //bricks
                  MyBrick(
                      brickX: brickX,
                      brickY: brickY,
                      brickWidth: brickWidth,
                      brickHeight: brickHeight,
                      brickBroken: brickBroken),
                ],
              ),
            ),
          ),
        ));
  }
}
