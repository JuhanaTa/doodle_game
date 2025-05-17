import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../doodle_game.dart';
import 'dart:math' as math;

class Trap extends SpriteComponent with HasGameReference<DoodleGame> {
  Trap({required super.position, required super.size, required super.sprite})
      : super(
          anchor: Anchor.center,
          children: [RectangleHitbox()],
        );

  final rand = math.Random();
  var velocity = Vector2(75, 0);
  double lastMoveChange = 0;
  double moveTimeOut = 0;

  @override
  void update(double dt) {
    super.update(dt);

    // figure out random move interval
    if(moveTimeOut == 0){
      // min 1 second, max 5 second
      moveTimeOut = 1 + 3 * rand.nextDouble();
    }

    lastMoveChange += dt;
    position += velocity * dt;

    if (lastMoveChange >= moveTimeOut) {

      if (velocity.x < 0) {
        velocity.x = 75;
      } else {
        velocity.x = -75;
      }

      lastMoveChange = 0;
    }
  }
}
