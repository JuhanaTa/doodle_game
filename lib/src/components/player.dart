import 'package:doodle_maze/src/components/booster.dart';
import 'package:doodle_maze/src/components/goal.dart';
import 'package:doodle_maze/src/components/spring.dart';
import 'package:doodle_maze/src/components/trap.dart';
import 'package:doodle_maze/src/config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../doodle_game.dart';
import 'brick.dart';

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameReference<DoodleGame> {
  Player({required this.velocity, required super.position, required super.size, required super.sprite})
      : super(anchor: Anchor.center, children: [CircleHitbox()]);

  var velocity = Vector2(0, 0);
  final dragCoolDown = 5;
  final gravity = Vector2(0, gravityY);

  double? highestPoint;
  double fallLength = 0.0;

  @override
  void update(double dt) {
    super.update(dt);
    velocity += gravity * dt;
    position += velocity * dt;

    // Score is increased by one when player passes a chunk (1 chunk is the range of 0-1000 of position.y/height)
    // E.g. if height is 25500 the score is 4, or if 24050 the score is 5
    // ChatGpt helped to make this calculation more simple.
    int newScore = 30 - ((y + 999) ~/ 1000);

    if (newScore >= 30) {
      game.heightScore.value = 30;
    } else if (newScore <= 0) {
      game.heightScore.value = 0;
    } else {
      game.heightScore.value = newScore;
    }

    // If the player is detected falling down,
    if (velocity.y >= 0) {

      if(sprite != game.playerSprite){sprite = game.playerSprite;}

      // Assign highestPoint only if it is null
      // with ??= dart operator
      highestPoint ??= position.y;

      // keep track of highest position under which the fall is calculated
      if (position.y < highestPoint!) {
        highestPoint = position.y;
      }

      // Calculate updated length of fall
      fallLength = position.y - highestPoint!;

      // Show fall alert if player has fallen enough
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
      if(sprite != game.jumpPlayerSprite){sprite = game.jumpPlayerSprite;}
      // Highest point will be resetted when falling ends.
      highestPoint = null;
      game.overlays.remove('FallAlert');
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    // Activate jump if player is detected falling down and colliding with brick.
    if (other is Brick && game.player.velocity.y >= 0) {
      velocity = Vector2(0, -brickVelocity);
      other.removeFromParent();
    }

    // Booster gives more velocity compared to normally jumping through bricks.
    if (other is Booster) {
      velocity = Vector2(0, -game.levelModifier.boosterVelocity);
      other.removeFromParent();
    }

    // Element which ends the game and causes player to win.
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

    // Activate spring if colliding with spring, the spring is not activated and the player is going upwards.
    if (other is Spring && !other.springActivated && game.player.velocity.y <= 0) {
      //set activated flag to not allow second collision
      other.springActivated = true;
      //push the player back
      velocity = Vector2(0, springVelocity);
      // + change the sprite to show activated spring
      other.sprite = game.springActiveSprite;
    }
  }
}
