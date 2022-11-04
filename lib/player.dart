import 'package:flutter/material.dart';
import './homepage.dart';

class MyPlayer extends StatelessWidget {
  final playerX;
  final playerWidth;

  MyPlayer({this.playerX, this.playerWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment((2*playerX + playerWidth)/(2-playerWidth), 0.9),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 10,
            width: MediaQuery.of(context).size.width * playerWidth / 2,
            color: Colors.deepOrange,
          ),
        ));
  }
}
