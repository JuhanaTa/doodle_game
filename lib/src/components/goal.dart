import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../doodle_game.dart';

class Goal extends SpriteComponent with HasGameReference<DoodleGame> {
  Goal({required super.position, required super.size, required super.sprite})
      : super(
          anchor: Anchor.center,
          children: [RectangleHitbox()],
        );
}
