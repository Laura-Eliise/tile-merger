import 'dart:math';
import 'package:flutter/cupertino.dart';

import '../services/audio.dart';
import '../static/helpers.dart';
import 'position.dart';
import 'tile.dart';
import '../static/constants.dart';

class Grid {
  final Function setNewState;
  final Function updateScore;
  int score = 0;
  double tileSize = -1;

  List<List<Tile>> tiles = List.generate(
      gridTileCount,
      (i) =>
          List.generate(gridTileCount, (j) => Tile(coords: Pos(x: j, y: i))));

  Grid({required this.setNewState, required this.updateScore});

  /* ----- GAME LOGIC ----- */

  // moves tiles towards the swipe direction.
  // if any tile was able to move, it return true.
  Future<bool> moveTiles(Direction swipe) async {
    MovementData data = MovementData(grid: clone());
    data = updateTiles(data, swipe);

    if (data.moved) {
      List<List<Tile>> grid = data.grid;

      // playing the movement animation
      for (var i = 0; i < gridTileCount; i++) {
        for (var j = 0; j < gridTileCount; j++) {
          tiles[i][j].xy = grid[i][j].xy;
        }
      }
      setNewState();
      await Future.delayed(delay);

      // setting values and setting tiles back to their original positions
      for (var i = 0; i < gridTileCount; i++) {
        for (var j = 0; j < gridTileCount; j++) {
          tiles[i][j].value = grid[i][j].value;
          tiles[i][j].xy = Pos(x: j, y: i);
          tiles[i][j].instant = true;
        }
      }

      await updateScore(score);
      setNewState();
      await Future.delayed(const Duration(milliseconds: 20));
    }
    return data.moved;
  }

  // Moves or merges all the tiles in the grid towards the swipe direction
  MovementData updateTiles(MovementData data, Direction swipe) {
    List<List<Tile>> grid = data.grid;
    var merged = false;
    switch (swipe) {
      case Direction.left:
        {
          for (var col = 0; col < gridTileCount; col++) {
            // mergedIndex makes sure that tiles are merged once in each row/col
            int mergedIndex = 0;
            for (var row = 1; row < gridTileCount; row++) {
              if (grid[col][row].value < 0) continue;

              if (grid[col][row - 1].value < 0 ||
                  grid[col][row - 1].value == grid[col][row].value) {
                for (var x = row - 1; x >= mergedIndex; x--) {
                  // merges two tiles of the same value together
                  if (grid[col][x].value == grid[col][row].value) {
                    grid[col][row].xy = Pos(x: x, y: col);
                    grid[col][x].value *= 2;
                    grid[col][row].value = -1;
                    mergedIndex = x + 1;
                    score += grid[col][x].value;
                    merged = true;
                    break;
                    // moves a tile furthest in the swipe direction as possible
                  } else if (grid[col][x].value > -1) {
                    grid[col][row].xy = Pos(x: x + 1, y: col);
                    grid[col][x + 1].value = grid[col][row].value;
                    grid[col][row].value = -1;
                    break;
                    // if we reach this part, then the tile at that place is empty
                  } else if (x == mergedIndex) {
                    grid[col][row].xy = Pos(x: x, y: col);
                    grid[col][x].value = grid[col][row].value;
                    grid[col][row].value = -1;
                    break;
                  }
                }

                if (!data.moved) data.moved = true;
              }
            }
          }

          break;
        }
      case Direction.right:
        {
          for (var col = 0; col < gridTileCount; col++) {
            // mergedIndex makes sure that tiles are merged once in each row/col
            int mergedIndex = gridTileCount - 1;
            for (var row = gridTileCount - 2; row >= 0; row--) {
              if (grid[col][row].value < 0) continue;

              if (grid[col][row + 1].value < 0 ||
                  grid[col][row + 1].value == grid[col][row].value) {
                for (var x = row + 1; x <= mergedIndex; x++) {
                  // merges two tiles of the same value together
                  if (grid[col][x].value == grid[col][row].value) {
                    grid[col][row].xy = Pos(x: x, y: col);
                    grid[col][x].value *= 2;
                    grid[col][row].value = -1;
                    score += grid[col][x].value;
                    mergedIndex = x - 1;
                    merged = true;
                    break;
                    // moves a tile furthest in the swipe direction as possible
                  } else if (grid[col][x].value > -1) {
                    grid[col][row].xy = Pos(x: x - 1, y: col);
                    grid[col][x - 1].value = grid[col][row].value;
                    grid[col][row].value = -1;
                    break;
                    // if we reach this part, then the tile at that place is empty
                  } else if (x == mergedIndex) {
                    grid[col][row].xy = Pos(x: x, y: col);
                    grid[col][x].value = grid[col][row].value;
                    grid[col][row].value = -1;
                    break;
                  }
                }
                if (!data.moved) data.moved = true;
              }
            }
          }
          break;
        }
      case Direction.up:
        {
          for (var row = 0; row < gridTileCount; row++) {
            // mergedIndex makes sure that tiles are merged once in each row/col
            int mergedIndex = 0;
            for (var col = 1; col < gridTileCount; col++) {
              if (grid[col][row].value < 0) continue;

              if (grid[col - 1][row].value < 0 ||
                  grid[col - 1][row].value == grid[col][row].value) {
                for (var y = col - 1; y >= mergedIndex; y--) {
                  // merges two tiles of the same value together
                  if (grid[y][row].value == grid[col][row].value) {
                    grid[col][row].xy = Pos(x: row, y: y);
                    grid[y][row].value *= 2;
                    grid[col][row].value = -1;
                    score += grid[y][row].value;
                    mergedIndex = y + 1;
                    merged = true;
                    break;
                    // moves a tile furthest in the swipe direction as possible
                  } else if (grid[y][row].value > -1) {
                    grid[col][row].xy = Pos(x: row, y: y + 1);
                    grid[y + 1][row].value = grid[col][row].value;
                    grid[col][row].value = -1;
                    break;
                    // if we reach this part, then the tile at that place is empty
                  } else if (y == mergedIndex) {
                    grid[col][row].xy = Pos(x: row, y: y);
                    grid[y][row].value = grid[col][row].value;
                    grid[col][row].value = -1;
                    break;
                  }
                }
                if (!data.moved) data.moved = true;
              }
            }
          }
          break;
        }
      case Direction.down:
        {
          for (var row = 0; row < gridTileCount; row++) {
            // mergedIndex makes sure that tiles are merged once in each row/col
            int mergedIndex = gridTileCount - 1;
            for (var col = gridTileCount - 2; col > -1; col--) {
              if (grid[col][row].value < 0) {
                continue;
              }

              if (grid[col + 1][row].value < 0 ||
                  grid[col + 1][row].value == grid[col][row].value) {
                for (var y = col + 1; y <= mergedIndex; y++) {
                  // merges two tiles of the same value together
                  if (grid[y][row].value == grid[col][row].value) {
                    grid[col][row].xy = Pos(x: row, y: y);
                    grid[y][row].value *= 2;
                    grid[col][row].value = -1;
                    score += grid[y][row].value;
                    mergedIndex = y - 1;
                    merged = true;
                    break;
                    // moves a tile furthest in the swipe direction as possible
                  } else if (grid[y][row].value > -1) {
                    grid[col][row].xy = Pos(x: row, y: y - 1);
                    grid[y - 1][row].value = grid[col][row].value;
                    grid[col][row].value = -1;
                    break;
                    // if we reach this part, then the tile at that place is empty
                  } else if (y == mergedIndex) {
                    grid[col][row].xy = Pos(x: row, y: y);
                    grid[y][row].value = grid[col][row].value;
                    grid[col][row].value = -1;
                    break;
                  }
                }
                if (!data.moved) data.moved = true;
              }
            }
          }
          break;
        }
    }

    if (merged) pop();
    return data;
  }

  GameOver checkForGameOver() {
    var isOver = true;

    // checking if there's any more free spaces
    for (var row in tiles) {
      for (var i = 0; i < gridTileCount; i++) {
        if (row[i].value < 0) {
          isOver = false;
        }
      }
    }

    // checking if a tile can merge vertically
    if (isOver) {
      for (var row in tiles) {
        for (var x = 1; x < gridTileCount; x++) {
          if (row[x].value == row[x - 1].value) {
            isOver = false;
          }
        }
      }
    }

    // checking if a tile can merge horizontally
    if (isOver) {
      for (var row = 0; row < gridTileCount; row++) {
        for (var col = 1; col < gridTileCount; col++) {
          if (tiles[col][row].value == tiles[col - 1][row].value) {
            isOver = false;
          }
        }
      }
    }

    // if the game is over, we check if the player reached the winning tile
    if (isOver) {
      var maxTileValue = 0;
      for (var row in tiles) {
        for (var i = 0; i < gridTileCount; i++) {
          if (maxTileValue < row[i].value) {
            maxTileValue = row[i].value;
          }
        }
      }

      if (maxTileValue >= (goalTile[gridTileCount] ?? 2048)) {
        return GameOver.win;
      } else {
        return GameOver.lose;
      }
    }

    return GameOver.none;
  }

  /* ----------     HELPERS    ---------- */

  Tile newTile({
    required int x,
    required int y,
    int? value,
  }) {
    return value == null
        ? Tile(coords: Pos(x: x, y: y), size: tileSize)
        : Tile(coords: Pos(x: x, y: y), value: value, size: tileSize);
  }

  // creates a clone of the grid
  List<List<Tile>> clone() {
    return List.generate(
      gridTileCount,
      (i) => List.generate(
        gridTileCount,
        (j) => newTile(
            x: tiles[i][j].x, y: tiles[i][j].y, value: tiles[i][j].value),
      ),
    );
  }

  // finds all the empty tiles in the grid
  List<Pos> findAllEmpty() {
    List<Pos> list = [];
    tiles.asMap().forEach((i, row) {
      row.asMap().forEach((j, elem) {
        if (row[j].value < 0) {
          list.add(Pos(x: j, y: i));
        }
      });
    });
    return list;
  }

  // generates a new tile into a random empty place on the grid
  void spawnRandomTile() {
    final random = Random();
    final int value = random.nextInt(10) < 1 ? 4 : 2;
    final List<Pos> emptyTiles = findAllEmpty();
    if (emptyTiles.isNotEmpty) {
      Pos pos = emptyTiles[random.nextInt(emptyTiles.length)];
      tiles[pos.y][pos.x].value = value;
    }
  }

  void reset(int gridSize) {
    tiles = List.generate(
        gridSize, (y) => List.generate(gridSize, (x) => newTile(x: x, y: y)));
    score = 0;
    init();
  }

  // remove the delay from all tiles for one update
  void setNoDelayOnceForAll() {
    for (var col = 0; col < gridTileCount; col++) {
      for (var row = 0; row < gridTileCount; row++) {
        tiles[col][row].instant = true;
      }
    }
  }

  void printGrid({List<List<Tile>>? grid, bool coords = false}) {
    grid ??= tiles;
    for (var row in tiles) {
      String str = "";
      for (var elem in row) {
        if (coords) {
          str += "${elem.xy} ";
        }
        str += "$elem  ";
      }
      debugPrint(str);
    }
    debugPrint("");
  }

  /* ---------- INITIALIZATION ---------- */

  void init() {
    if (!(tiles.expand((e) => e).any((element) => element.value != -1))) {
      spawnRandomTile();
      spawnRandomTile();
      spawnRandomTile();
    }
  }

  // updates the size of all the tiles
  void updateSizeAll(double gridWidth) {
    tileSize = (gridWidth - gridTileGap * (gridTileCount + 1)) / gridTileCount;

    for (var i = 0; i < gridTileCount; i++) {
      for (var j = 0; j < gridTileCount; j++) {
        tiles[i][j].setSize(tileSize);
      }
    }
  }
}
