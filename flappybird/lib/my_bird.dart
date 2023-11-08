import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  MyBird({
    this.birdY,
    required this.birdWidth,
    required this.birdHeight,
  });

  final birdY;
  final double birdWidth; // normal double value for width
  final double birdHeight; // out of 2, 2 being the entire height of the screen

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)),
      // x-axis, -1 of the left, 1 of the right
      // y-axis, -1 on the top, 1 of the bottom
      child: Container(
        child: Image.asset(
          'images/flappy_bird.png',
          width: MediaQuery.of(context).size.height * birdWidth / 2,
          height: MediaQuery.of(context).size.height * 3 / 4 * birdHeight / 2,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
