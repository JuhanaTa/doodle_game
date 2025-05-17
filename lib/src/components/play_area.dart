import 'dart:async';
import 'package:doodle_maze/src/config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../doodle_game.dart';

class PlayArea extends RectangleComponent
    with DragCallbacks, HasGameReference<DoodleGame> {
  PlayArea()
      : super(
          paint: Paint()..color = Colors.transparent,
          children: [RectangleHitbox()],
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(playWidth, playHeight);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    // Avoid dragUpdates if the gameplay is not active
    if (game.gameState == GameState.playing){
      game.player.position.x = (game.player.position.x + event.localDelta.x).clamp(0, cameraWidth);
    }
  }

  // In render the gridlines are drawn for the play area.
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Use gridsize according to the width of bricks
    const double gridSize = brickWidth;

    // Define paint for drawLine + assign width and color.
    final Paint gridPaint = Paint();
    gridPaint.color = Colors.grey;
    gridPaint.strokeWidth = 0.75;


    // Draw vertical lines
    for (double x = 0; x <= size.x - 1; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.y), gridPaint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.y; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.x, y), gridPaint);
    }
  }
}
