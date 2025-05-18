import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../doodle_game.dart';
import 'dart:math' as math;

class Spring extends SpriteComponent with HasGameReference<DoodleGame> {
  Spring({required super.position, required super.size, required super.sprite})
      : super(
          anchor: Anchor.center,
          children: [RectangleHitbox()],
        ) {
    // Rotate spring to face downwards since it will push player downwards when collided.
    scale = Vector2(1, -1);
  }

  bool springActivated = false;
}
