import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:twenty_forty_eight/widgets/change_grid_size_text.dart';

import '../services/db.dart';
import '../static/constants.dart';
import '../static/helpers.dart';

import '../widgets/grid_background.dart';
import '../widgets/info_and_new_game.dart';

import '../widgets/title_and_score.dart';
import 'game_over.dart';
import 'grid.dart';
import 'pop_up.dart';

class Game extends StatefulWidget {
  final String title;
  final DB db;

  const Game({
    super.key,
    required this.title,
    required this.db,
  });

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Grid grid;
  int score = 0;
  int highScore = 0;
  bool swipeLock = false;
  GameOver gameState = GameOver.none;
  PopUp? popUp;
  // bool popUp = false;
  // late Function popUpFunc = decreaseGridSize;

  @override
  void initState() {
    grid = Grid(updateScore: updateScore, setNewState: setNewState);
    _init();
    super.initState();
  }

  Future<void> _init() async {
    highScore = await widget.db.highScore;
    setNewState();
  }

  Future<void> updateScore(int newScore) async {
    score = newScore;
    if (score > highScore) {
      highScore = score;
    }
    setState(() {
      score = score;
      highScore = highScore;
    });
  }

  // callback function for a swipe gesture
  // moves or merges tiles towards the swipe direction if possible
  // then checks if the game is over
  void swipeCallback(Direction swipe) async {
    setState(() {
      swipeLock = true;
    });

    if (await grid.moveTiles(swipe)) {
      grid.spawnRandomTile();
    }

    var state = grid.checkForGameOver();
    if (state != GameOver.none) {
      setState(() {
        gameState = state;
      });
    }

    setState(() {
      grid = grid;
      swipeLock = false;
    });
  }

  Future<void> increaseGridSize(double gridWidth) async {
    popUp = null;
    if (gridTileCount < maxTileCount) {
      await widget.db.saveHighScore(highScore: highScore, id: gridTileCount);
      gridTileCount++;
      reset();

      grid.tileSize = -1;
      highScore = await widget.db.highScore;
      grid.setNoDelayOnceForAll();
      setNewState();
    }
  }

  Future<void> decreaseGridSize(double gridWidth) async {
    popUp = null;
    if (gridTileCount > minTileCount) {
      await widget.db.saveHighScore(highScore: highScore, id: gridTileCount);
      gridTileCount--;
      reset();

      grid.tileSize = -1;
      highScore = await widget.db.highScore;
      grid.setNoDelayOnceForAll();
      setNewState();
    }
  }

  void throwPopup({required Function func, required String warning}) {
    setState(() {
      popUp = PopUp(
        warning: warning,
        yesFunc: func,
        noFunc: () => setState(() => popUp = null),
      );
    });
  }

  Future<void> reset([double _ = 0]) async {
    gameState = GameOver.none;
    grid.reset(gridTileCount);
    score = 0;
    popUp = null;
    setNewState();
  }

  void setNewState() {
    setState(() {
      grid = grid;
      score = score;
      highScore = highScore;
      swipeLock = swipeLock;
      gameState = gameState;
      popUp = popUp;
    });
  }

  double getSize(BuildContext context) {
    return MediaQuery.of(context).size.width <
            MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    if (grid.tileSize < 0) {
      grid.updateSizeAll(getSize(context) - 20);
      grid.init();
      setNewState();
    }

    return Scaffold(
      body: Stack(children: [
        SwipeDetector(
          onSwipeLeft: (offset) =>
              {if (!swipeLock) swipeCallback(Direction.left)},
          onSwipeRight: (offset) =>
              {if (!swipeLock) swipeCallback(Direction.right)},
          onSwipeUp: (offset) => {if (!swipeLock) swipeCallback(Direction.up)},
          onSwipeDown: (offset) =>
              {if (!swipeLock) swipeCallback(Direction.down)},
          child: Padding(
            padding: const EdgeInsets.all(10),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TitleAndScore(
                title: "${goalTile[gridTileCount]}",
                score: score,
                highScore: highScore,
              ),
              const SizedBox(height: 5),
              InfoAndNewGame(
                  goalTile: "${goalTile[gridTileCount]}",
                  reset: () => {
                        score > 0 && gameState == GameOver.none
                            ? throwPopup(
                                warning: "Are you sure you want to reset?",
                                func: reset)
                            : reset()
                      }),
              const SizedBox(height: 20),
              Stack(
                children: [
                  GridBackground(tileCount: gridTileCount),
                  ...grid.tiles.expand((row) => row).map((tile) => tile.widget),
                  GameOverState(
                      reset: reset, gameOver: gameState, score: score),
                  popUp ?? const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 15),
              ChangeGridSizeText(
                decreaseGridSize: () => {
                  score > 0 &&
                          gameState == GameOver.none &&
                          gridTileCount > minTileCount
                      ? throwPopup(
                          warning:
                              "Are you sure you want to decrease the grid size?",
                          func: decreaseGridSize)
                      : decreaseGridSize(getSize(context) - 20)
                },
                increaseGridSize: () => {
                  score > 0 &&
                          gameState == GameOver.none &&
                          gridTileCount < maxTileCount
                      ? throwPopup(
                          warning:
                              "Are you sure you want to increase the grid size?",
                          func: increaseGridSize)
                      : increaseGridSize(getSize(context) - 20)
                },
              )
            ]),
          ),
        ),
      ]),
    );
  }
}
