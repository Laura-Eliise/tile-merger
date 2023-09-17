import 'package:flutter/cupertino.dart';

import '../static/constants.dart';
import '../static/helpers.dart';
import '../static/theme.dart';

class GameOverState extends StatelessWidget {
  final Function reset;
  final GameOver gameOver;
  final int score;

  const GameOverState(
      {super.key, required this.gameOver, this.score = 0, required this.reset});

  @override
  Widget build(BuildContext context) {
    return gameOver != GameOver.none
        ? LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              var width = constraints.maxWidth;
              return GestureDetector(
                  onTap: () => reset(),
                  child: Container(
                    height: width,
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        color: gameOver == GameOver.win
                            ? tileColors[2048]?.withOpacity(0.7)
                            : tileColors[0]?.withOpacity(0.7)),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          gameOver == GameOver.win ? "You Won!" : "Game Over",
                          style: const TextStyle(
                              color: lightTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0),
                        ),
                        Text(
                          "score: $score",
                          style: const TextStyle(
                              color: lightTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Tap to start again",
                          style: TextStyle(
                              color: lightTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                      ],
                    )),
                  ));
            },
          )
        : const SizedBox.shrink();
  }
}
