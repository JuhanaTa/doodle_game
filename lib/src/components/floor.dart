import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Floor extends PositionComponent with CollisionCallbacks {
  Floor({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft) {
    add(RectangleHitbox());
  }
}
