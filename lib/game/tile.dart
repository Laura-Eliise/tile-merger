import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../static/constants.dart';
import '../static/theme.dart';
import 'position.dart';

class Tile {
  bool instant;
  Pos coords;
  double size;
  int value;

  int get x => coords.x;
  int get y => coords.y;
  Pos get xy => coords;
  set x(int x) => coords.x = x;
  set y(int y) => coords.y = y;
  set xy(Pos coords) => this.coords = coords;

  void setSize(double size) {
    if (size.isNegative) {
      throw Exception("A tiles size can't be negative!");
    }
    this.size = size;
  }

  Widget get widget {
    var noDelay = instant;
    instant = false;

    return value > 0
        ? AnimatedPositioned(
            duration: value > 0 && !noDelay ? delay : Duration.zero,
            width: size,
            height: size,
            top: gridTileGap + y * size + y * gridTileGap,
            left: gridTileGap + x * size + x * gridTileGap,
            child: Container(
              width: size,
              height: size,
              padding: EdgeInsets.all(size * 0.1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: tileColors.containsKey(value)
                    ? tileColors[value]
                    : tileColors[-1],
              ),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "$value",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: value < 8 ? darkTextColor : lightTextColor),
                ),
              ),
            ))
        : const SizedBox.shrink();
  }

  Tile({
    required this.coords,
    this.value = -1,
    this.size = -1,
    this.instant = false,
  });
}
