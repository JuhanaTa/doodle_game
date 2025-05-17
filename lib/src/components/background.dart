import 'dart:math';
import 'package:doodle_maze/src/config.dart';
import 'package:doodle_maze/src/doodle_game.dart';
import 'package:flame/components.dart';

class Background extends SpriteComponent with HasGameReference<DoodleGame> {
  Background({required super.sprite})
      : super(
          anchor: Anchor.center,
          position: Vector2(0, cameraHeight / 2),
        );

  @override
  void onMount() {
    super.onMount();

    size = Vector2.all(max(
      game.camera.visibleWorldRect.width,
      game.camera.visibleWorldRect.height,
    ));
  }
}
