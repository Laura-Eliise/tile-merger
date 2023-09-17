import 'package:flutter/cupertino.dart';

import '../static/constants.dart';
import '../static/theme.dart';

class ScoreBox extends StatelessWidget {
  final int? score;
  final int? highScore;
  const ScoreBox({super.key, this.score, this.highScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: darkBackgroundColor,
      ),
      child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 3),
          child: Column(
            children: [
              Text(
                "${highScore != null ? "HIGH " : ""}SCORE",
                style: TextStyle(
                    color: tileColors[0],
                    fontWeight: FontWeight.bold,
                    fontSize: 10),
              ),
              Text(
                "${score ?? highScore ?? 0}",
                style: const TextStyle(
                    color: lightBackgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              )
            ],
          )),
    );
  }
}