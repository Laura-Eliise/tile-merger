class Pos {
  int x;
  int y;

  void setPos({required int x, required int y}) {
    this.x = x;
    this.y = y;
  }

  @override
  operator ==(Object other) {
    return identical(this, other) ||
        other is Pos && other.x == x && other.y == y;
  }

  @override
  String toString() {
    return "$x,$y";
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  Pos({required this.x, required this.y});
}
