import 'package:doodle_maze/src/doodle_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Wall extends PositionComponent with CollisionCallbacks, HasGameReference<DoodleGame> {
  Wall({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft) {
    add(RectangleHitbox());
  }
}
