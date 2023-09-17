import '../game/tile.dart';

enum Direction { left, right, up, down }

enum GameOver { none, win, lose }

class MovementData {
  bool moved;
  List<List<Tile>> grid;

  MovementData({
    required this.grid,
    this.moved = false,
  });
}