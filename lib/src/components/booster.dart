import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../doodle_game.dart';

class Booster extends SpriteComponent with HasGameReference<DoodleGame> {
  Booster({
    required super.position,
    required super.size,
    required super.sprite
  }) : super(
          anchor: Anchor.center,
          children: [RectangleHitbox()],
        );
}
