import 'dart:async';
import 'dart:ui';

import 'package:doodle_maze/src/components/spring.dart';
import 'package:doodle_maze/src/components/booster.dart';
import 'package:doodle_maze/src/components/brick.dart';
import 'package:doodle_maze/src/components/goal.dart';
import 'package:doodle_maze/src/components/play_area.dart';
import 'package:doodle_maze/src/components/player.dart';
import 'package:doodle_maze/src/components/trap.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_kenney_xml/flame_kenney_xml.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import 'config.dart';
import 'dart:math' as math;

enum GameState { start, playing, lose, win }

class DoodleGame extends FlameGame with HasCollisionDetection, KeyboardEvents {
  DoodleGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: cameraWidth,
            height: cameraHeight,
          ),
        );

  // Override of the background color to allow transparent background
  @override
  Color backgroundColor() => const Color(0x00000000);

  // element references
  late Player player;
  late PlayArea playArea;
  late final XmlSpriteSheet bricks;
  late final XmlSpriteSheet characters;
  late final XmlSpriteSheet extraSprites;

  LevelModifier levelModifier = LevelModifier();

  // Score saving elements
  final highScoreBox = Hive.box('highScore');

  // Generate the steps where bricks are rendered based on the playheight
  List<double> generateRendableBrickHeights(playHeight, step) {
    List<double> renderHeights = [];
    double currentRenderH = 600.0;

    while (currentRenderH <= playHeight) {
      renderHeights.add(currentRenderH);
      currentRenderH += step;
    }

    return renderHeights;
  }

  late GameState _gameState;
  GameState get gameState => _gameState;
  set gameState(GameState gameState) {
    _gameState = gameState;
    switch (gameState) {
      case GameState.start:
        overlays.remove(GameState.lose.name);
        overlays.remove(GameState.win.name);
        overlays.remove('FallAlert');
        overlays.remove('ScoreCounter');
        overlays.add(gameState.name);
      case GameState.lose:
        overlays.remove('FallAlert');
        overlays.add(gameState.name);
      case GameState.win:
        overlays.remove('FallAlert');
        overlays.add(gameState.name);
      case GameState.playing:
        overlays.remove(GameState.start.name);
        overlays.remove(GameState.lose.name);
        overlays.remove(GameState.win.name);
    }
  }

  double get width => size.x;
  double get height => size.y;
  late ValueNotifier<int> heightScore = ValueNotifier(0);
  late ValueNotifier<int> gameDifficulty = ValueNotifier(0);
  late ValueNotifier<Map<int, int>> highScores = ValueNotifier({});

  final rand = math.Random();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    final sprites = await Future.wait([
      XmlSpriteSheet.load(
        imagePath: 'spritesheet_tiles.png',
        xmlPath: 'spritesheet_tiles.xml',
      ),
      XmlSpriteSheet.load(
        imagePath: 'spritesheet-enemies-default.png',
        xmlPath: 'spritesheet-enemies-default.xml',
      ),
      XmlSpriteSheet.load(
        imagePath: 'spritesheet-tiles-default.png',
        xmlPath: 'spritesheet-tiles-default.xml',
      ),
    ]);

    bricks = sprites[0];
    characters = sprites[1];
    extraSprites = sprites[2];

    // Fetch highscores from hive.
    highScores.value = fetchHighScores();

    // Use camera on topLeft while in level menu.
    camera.viewfinder.anchor = Anchor.topLeft;

    // Introduce PlayArea already
    playArea = PlayArea();
    world.add(playArea);

    // Assign starting game state
    gameState = GameState.start;
  }

  // Saves highcores as Map to hive to get them after application restart
  void saveHighScore(int level, int score) {
    Map<int, int> scores = fetchHighScores();
    int currentHighScore = scores[level] ?? 0;

    // Only save the new score if it exceeds the current/old highScore
    if (score > currentHighScore) {
      scores[level] = score;
      highScoreBox.put('savedScores', scores);
      highScores.value = scores;
    }
  }

  // Fetches highscores from hive
  Map<int, int> fetchHighScores() {
    Map<int, int> scores =
        Map<int, int>.from(highScoreBox.get('savedScores', defaultValue: {}));
    return scores;
  }

  void handleElementRemove() {
    world.removeAll(world.children.query<Player>());
    world.removeAll(world.children.query<Booster>());
    world.removeAll(world.children.query<Brick>());
    world.removeAll(world.children.query<Goal>());
    world.removeAll(world.children.query<Trap>());
    world.removeAll(world.children.query<Spring>());
  }

  void startGame() async {
    handleElementRemove();

    gameState = GameState.playing;
    overlays.add('ScoreCounter');

    camera.viewfinder.anchor = Anchor.center;

    // Spawn in the player
    player = Player(
        position: Vector2(playWidth / 2, playHeight - 800),
        velocity: Vector2(0, 0),
        sprite: characters.getSprite('frog_idle'));

    world.add(player);

    // Camera must follow the player
    camera.follow(player, verticalOnly: true, snap: true);

    // Define the locations where bricks are rendered
    List<double> brickRenderHeights = generateRendableBrickHeights(
        playHeight, levelModifier.brickSpawnSeparation);

    int boosterSpawnDistance = 0;
    int trapSpawnDistance = 0;
    int springSpawnDistance = 0;

    // Include bricks in defined locations
    for (int i = 0; i < brickRenderHeights.length; i++) {

      // Define random x positions for elements
      final brickX = rand.nextDouble() * (playWidth - brickWidth);
      final boosterX = rand.nextDouble() * (playWidth - brickWidth);
      final trapX = rand.nextDouble() * (playWidth - brickWidth);
      final springX = rand.nextDouble() * (playWidth - brickWidth);

      // Include booster if there is enough height between the other boosters.
      if (boosterSpawnDistance >=
          levelModifier.boosterSpawnSeparation.toInt()) {
        final booster = Booster(
            position: Vector2(
                boosterX + boosterWidth / 2, brickRenderHeights[i] - 50),
            size: Vector2(boosterWidth, boosterHeight),
            sprite: extraSprites.getSprite('block_exclamation_active'));
        world.add(booster);
        boosterSpawnDistance = 0;
      }

      boosterSpawnDistance += levelModifier.brickSpawnSeparation.toInt();

      // Trap must have level specific distance off other trap, and
      // it can't spawn in the bottom part of the playArea to make sure the player can spawn correctly (first possible spawn height 30000 - 1000).
      // 100 offset to not spawn on top of brick or spring
      if (trapSpawnDistance >= levelModifier.trapSpawnSeparation.toInt() &&
          brickRenderHeights[i] <= playHeight - 1000) {
        final trap = Trap(
            position:
                Vector2(trapX + trapWidth / 2, brickRenderHeights[i] - 100),
            size: Vector2(trapWidth, trapheight),
            sprite: extraSprites.getSprite('bomb'));
        world.add(trap);
        trapSpawnDistance = 0;
      }

      trapSpawnDistance += levelModifier.brickSpawnSeparation.toInt();

      // Also spring must have level specific distance off other spring, and
      // it can't spawn in the bottom part of the playArea where player spawns (first possible spawn height 30000 - 1600).
      // 150 offset to not spawn on top of brick or spring
      if (springSpawnDistance >= levelModifier.springSpawnSeparation.toInt() &&
          brickRenderHeights[i] <= playHeight - 1600) {
        final backPusher = Spring(
            position: Vector2(springX + springWidth / 2, brickRenderHeights[i] - 150),
            size: Vector2(springWidth, springHeight),
            sprite: extraSprites.getSprite('spring'));
        world.add(backPusher);
        springSpawnDistance = 0;
      }

      springSpawnDistance += levelModifier.brickSpawnSeparation.toInt();

      // First brick is the goal, rendered top to down.
      if (i == 0) {
        final goal = Goal(
            position:
                Vector2(goalHeight + goalWidth / 2, brickRenderHeights[i]),
            size: Vector2(goalWidth, goalHeight),
            sprite: extraSprites.getSprite('gem_yellow'));
        world.add(goal);
      } else {
        final brick = Brick(
          position: Vector2(brickX + brickWidth / 2, brickRenderHeights[i]),
          size: Vector2(brickWidth, brickHeight),
          sprite: bricks.getSprite('grass.png'),
        );
        world.add(brick);
      }
    }
    // game ends when player touches the golden gem on top
  }

  void returnToLevels() {
    gameState = GameState.start;
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.arrowRight:
    }
    return KeyEventResult.handled;
  }
}
