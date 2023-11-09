import 'dart:async';
import 'package:flappybird/barriers.dart';
import 'package:flappybird/my_bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bird variables
  static double birdY = 0;
  double initialPosition = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9; // how strong the gravity is
  double velocity = 2.0; // how strong the jump is
  double birdWidth = 0.1; // out of 2, 2 being the entire width of the screen
  double birdHeight = 0.1; // out of 2, 2 being the entire height of the screen

  // game settings
  bool gameHasStarted = false;

  // barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5; // out of 2
  List<List<double>> barrierHeight = [
    // out of 2, where 2 is the entire height of the screen
    // [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  static List<double> barrierX2 = [5, 5 + 1.5];
  static double barrierWidth2 = 0.5;
  List<List<double>> barrierHeight2 = [
    [0.7, 0.3],
    [0.3, 0.7],
  ];

  static List<double> barrierX3 = [8, 8 + 1.5];
  static double barrierWidth3 = 0.5;
  List<List<double>> barrierHeight3 = [
    [0.2, 0.8],
    [0.8, 0.2],
  ];

  static List<double> barrierX4 = [11, 11 + 1.5];
  static double barrierWidth4 = 0.5;
  List<List<double>> barrierHeight4 = [
    [0.8, 0.2],
    [0.1, 0.9],
  ];

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(
      Duration(milliseconds: 10),
      (timer) {
        // a real physical jump is the same as an upside down parabola
        // so this is a simple quadratic equation
        height = (gravity * time * time) + (velocity * time);

        setState(() {
          birdY = initialPosition - height;
          // subtracting mean the bird is moving upward and go higher
        });

        // Update barrier positions
        for (int i = 0; i < barrierX.length; i++) {
          // Subtract a small value to move the barriers to the left
          barrierX[i] -= 0.01; // Adjust the value as needed
        }

        for (int i = 0; i < barrierX2.length; i++) {
          barrierX2[i] -= 0.01; // Adjust the value as needed
        }

        for (int i = 0; i < barrierX3.length; i++) {
          barrierX3[i] -= 0.01; // Adjust the value as needed
        }

        for (int i = 0; i < barrierX4.length; i++) {
          barrierX4[i] -= 0.01; // Adjust the value as needed
        }

        // check if bird is dead
        if (birdIsDead()) {
          timer.cancel();
          gameHasStarted = false;
          _showDialog();
        }

        // keep the time going
        time += 0.01;
      },
    );
  }

  void _showDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Center(
            child: Text(
              'G A M E  O V E R',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(7),
                  color: Colors.white,
                  child: Text(
                    'P L A Y  A G A I N',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    // restart the game some variables need to be changed back to initial value
    Navigator.pop(context); // dismiss the alert dialog
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPosition = birdY;
      barrierX = [2, 2 + 1.5];
      barrierX2 = [5, 5 + 1.5];
      barrierX3 = [8, 8 + 1.5];
      barrierX4 = [11, 11 + 1.5];
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPosition = birdY;
    });
  }

  bool birdIsDead() {
    // check if the bird is hitting the top or the bottoms of the screen
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    // hits barriers
    // check if bird is within x coordinates and y coordinates of barriers
    // checking the x and y coordinates of the barriers
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }

    for (int i = 0; i < barrierX2.length; i++) {
      if (barrierX2[i] <= birdWidth &&
          barrierX2[i] + barrierWidth2 >= -birdWidth &&
          (birdY <= -1 + barrierHeight2[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight2[i][1])) {
        return true;
      }
    }

    for (int i = 0; i < barrierX3.length; i++) {
      if (barrierX3[i] <= birdWidth &&
          barrierX3[i] + barrierWidth3 >= -birdWidth &&
          (birdY <= -1 + barrierHeight3[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight3[i][1])) {
        return true;
      }
    }

    for (int i = 0; i < barrierX4.length; i++) {
      if (barrierX4[i] <= birdWidth &&
          barrierX4[i] + barrierWidth4 >= -birdWidth &&
          (birdY <= -1 + barrierHeight4[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight4[i][1])) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment(0, -0.5),
                        child: Text(
                          gameHasStarted ? '' : 'TAP TO PLAY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ),

                      MyBird(
                        birdY: birdY,
                        birdHeight: birdHeight,
                        birdWidth: birdWidth,
                      ),

                      // top barrier 0
                      MyBarrier(
                        isThisBottomBarrier: false,
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][0],
                      ),

                      // bottom barrier 0
                      MyBarrier(
                        isThisBottomBarrier: true,
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                      ),

                      // top barrier 1
                      MyBarrier(
                        isThisBottomBarrier: false,
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                      ),

                      // bottom barrier 1
                      MyBarrier(
                        isThisBottomBarrier: true,
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                      ),

                      /////////////////////////////////////////////////////////////////////////

                      // Render additional barriers
                      MyBarrier(
                        isThisBottomBarrier: false,
                        barrierX: barrierX2[0],
                        barrierWidth: barrierWidth2,
                        barrierHeight: barrierHeight2[0][0],
                      ),

                      MyBarrier(
                        isThisBottomBarrier: true,
                        barrierX: barrierX2[0],
                        barrierWidth: barrierWidth2,
                        barrierHeight: barrierHeight2[0][1],
                      ),

                      MyBarrier(
                        isThisBottomBarrier: false,
                        barrierX: barrierX2[1],
                        barrierWidth: barrierWidth2,
                        barrierHeight: barrierHeight2[1][0],
                      ),

                      MyBarrier(
                        isThisBottomBarrier: true,
                        barrierX: barrierX2[1],
                        barrierWidth: barrierWidth2,
                        barrierHeight: barrierHeight2[1][1],
                      ),

                      ////////////////////////////////////////////////////////////////////////////////

                      // Render additional barriers
                      MyBarrier(
                        isThisBottomBarrier: false,
                        barrierX: barrierX3[0],
                        barrierWidth: barrierWidth3,
                        barrierHeight: barrierHeight3[0][0],
                      ),

                      MyBarrier(
                        isThisBottomBarrier: true,
                        barrierX: barrierX3[0],
                        barrierWidth: barrierWidth3,
                        barrierHeight: barrierHeight3[0][1],
                      ),

                      MyBarrier(
                        isThisBottomBarrier: false,
                        barrierX: barrierX3[1],
                        barrierWidth: barrierWidth3,
                        barrierHeight: barrierHeight3[1][0],
                      ),

                      MyBarrier(
                        isThisBottomBarrier: true,
                        barrierX: barrierX3[1],
                        barrierWidth: barrierWidth3,
                        barrierHeight: barrierHeight3[1][1],
                      ),

                      ////////////////////////////////////////////////////////////////////////////////

                      // Render additional barriers
                      MyBarrier(
                        isThisBottomBarrier: false,
                        barrierX: barrierX4[0],
                        barrierWidth: barrierWidth4,
                        barrierHeight: barrierHeight4[0][0],
                      ),

                      MyBarrier(
                        isThisBottomBarrier: true,
                        barrierX: barrierX4[0],
                        barrierWidth: barrierWidth4,
                        barrierHeight: barrierHeight4[0][1],
                      ),

                      MyBarrier(
                        isThisBottomBarrier: false,
                        barrierX: barrierX4[1],
                        barrierWidth: barrierWidth4,
                        barrierHeight: barrierHeight4[1][0],
                      ),

                      MyBarrier(
                        isThisBottomBarrier: true,
                        barrierX: barrierX4[1],
                        barrierWidth: barrierWidth4,
                        barrierHeight: barrierHeight4[1][1],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.brown[700],
                // child: Column(
                //   children: [
                //     SizedBox(
                //       height: 30,
                //     ),
                //     Text(
                //       'CREATED BY JINHENG',
                //       style: TextStyle(
                //         fontSize: 20,
                //         fontWeight: FontWeight.normal,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
