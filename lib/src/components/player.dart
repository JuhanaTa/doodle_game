
import 'package:doodle_maze/src/components/booster.dart';
import 'package:doodle_maze/src/components/goal.dart';
import 'package:doodle_maze/src/components/trap.dart';
import 'package:doodle_maze/src/components/wall.dart';
import 'package:doodle_maze/src/config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../doodle_game.dart';
import 'brick.dart';

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameReference<DoodleGame> {
  Player({required this.velocity, required super.position, required super.sprite})
      : super(anchor: Anchor.center, children: [RectangleHitbox()]);

  var velocity = Vector2(0, 0);
  final dragCoolDown = 5;
  final gravity = Vector2(0, 300);

  double? highestPoint;
  double fallLength = 0.0;

  @override
  void update(double dt) {
    super.update(dt);
    velocity += gravity * dt;
    position += velocity * dt;

    int newScore = 30 - (((position.y + 999) ~/ 1000) * 1000 / 1000).toInt();

    if (newScore >= 30) {
      game.heightScore.value = 30;
    } else if (newScore <= 0) {
      game.heightScore.value = 0;
    } else {
      game.heightScore.value = newScore;
    }

    // If the player is detected falling down,
    if (velocity.y >= 0) {
      sprite = game.characters.getSprite('frog_idle');
      // Assign highestPoint only if it is null
      // with ??= dart operator
      highestPoint ??= position.y;

      if (position.y < highestPoint!) {
        highestPoint = position.y;
      }

      // Calculate updated length of fall
      fallLength = position.y - highestPoint!;

      if (fallLength > cameraHeight / 3) {
        game.overlays.add('FallAlert');
      }

      // If the player falls down too much, end the game.
      // Or player falls off the playe area, the game will end
      if (fallLength > cameraHeight * 1.0 || position.y >= playHeight) {
        // Only set heighScore to 0 if the player falls out of the playarea
        if (position.y >= playHeight) {
          game.heightScore.value = 0;
        }

        game.gameState = GameState.lose;

        // Save highScore
        game.saveHighScore(game.gameDifficulty.value, game.heightScore.value);

        game.handleElementRemove();
      }
    } else {
      // Highest point will be resetted when falling ends.
      sprite = game.characters.getSprite('frog_jump');
      highestPoint = null;
      game.overlays.remove('FallAlert');
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Wall) {
      velocity = Vector2(0, -brickVelocity);
    }

    if (other is Brick && game.player.velocity.y >= 0) {
      velocity = Vector2(0, -brickVelocity);
      other.removeFromParent();
    }

    if (other is Booster) {
      velocity = Vector2(0, -game.levelModifier.boosterVelocity);
      other.removeFromParent();
    }

    if (other is Goal) {
      game.heightScore.value = 30;
      game.gameState = GameState.win;

      // Save win highScore
      game.saveHighScore(game.gameDifficulty.value, game.heightScore.value);

      game.handleElementRemove();
    }

    // player loses if collide with bombs/traps
    if (other is Trap) {
      game.gameState = GameState.lose;
      // Save highScore
      game.saveHighScore(game.gameDifficulty.value, game.heightScore.value);
      game.handleElementRemove();
    }
  }
}
