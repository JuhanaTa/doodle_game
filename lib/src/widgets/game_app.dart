import 'package:doodle_maze/src/config.dart';
import 'package:doodle_maze/src/doodle_game.dart';
import 'package:doodle_maze/src/widgets/fall_alert.dart';
import 'package:doodle_maze/src/widgets/game_ending_screen.dart';
import 'package:doodle_maze/src/widgets/level_screen.dart';
import 'package:doodle_maze/src/widgets/score_counter.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final DoodleGame game;

  @override
  void initState() {
    super.initState();
    game = DoodleGame();
  }

  void handleStartGame(int difficulty) {
    // difficulty 0 represents "try again"
    // and therefore want to use current difficulty that already exists
    if (difficulty != 0) {
      game.gameDifficulty.value = difficulty;
    }

    // Define/change the different difficulty modifiers
    if (game.gameDifficulty.value == 1) {
      game.levelModifier.boosterVelocity = boosterVelocity;
      game.levelModifier.boosterSpawnSeparation = boosterSpawnSeparation;
      game.levelModifier.brickSpawnSeparation = brickSpawnSeparation;
      game.levelModifier.trapSpawnSeparation = trapSpawnSeparation;
      game.levelModifier.springSpawnSeparation = springSpawnSeparation;
    } else if (game.gameDifficulty.value == 2) {
      game.levelModifier.boosterVelocity = boosterVelocityMedium;
      game.levelModifier.boosterSpawnSeparation = boosterSpawnSeparationMedium;
      game.levelModifier.brickSpawnSeparation = brickSpawnSeparationMedium;
      game.levelModifier.trapSpawnSeparation = trapSpawnSeparationMedium;
      game.levelModifier.springSpawnSeparation = springSpawnSeparationMedium;
    } else {
      game.levelModifier.boosterVelocity = boosterVelocityHard;
      game.levelModifier.boosterSpawnSeparation = boosterSpawnSeparationHard;
      game.levelModifier.brickSpawnSeparation = brickSpawnSeparationHard;
      game.levelModifier.trapSpawnSeparation = trapSpawnSeparationHard;
      game.levelModifier.springSpawnSeparation = springSpawnSeparationHard;
    }

    game.startGame();
  }

  void handleLevelScreen() {
    game.returnToLevels();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/colored_grass.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: FittedBox(
                      child: SizedBox(
                        width: cameraWidth,
                        height: cameraHeight,
                        child: GameWidget(
                          game: game,
                          overlayBuilderMap: {
                            // If player is falling too much, add fall alert overlay.
                            'FallAlert': (context, overlayGame) =>
                                const FallAlert(
                                    fallAlertText: 'Stop falling or you lose!'),
                            'ScoreCounter': (context, overlayGame) =>
                                ScoreCounter(
                                    currentScore: game.heightScore,
                                    highScore: game.highScores.value,
                                    difficulty: game.gameDifficulty.value),
                            GameState.start.name: (context, overlayGame) =>
                                LevelScreen(handleStartGame,
                                    highScore: game.highScores.value),
                            GameState.lose.name: (context, overlayGame) =>
                                GameEndingScreen(
                                    handleStartGame, handleLevelScreen,
                                    gameEndStatus: 'You lost the game!',
                                    gameEndDesc:
                                        'No worries! You can always try again!',
                                    highScore: game.highScores.value,
                                    difficulty: game.gameDifficulty.value),

                            GameState.win.name: (context, overlayGame) =>
                                GameEndingScreen(
                                    handleStartGame, handleLevelScreen,
                                    gameEndStatus: 'WOW! You won!',
                                    gameEndDesc: 'Want to try again?',
                                    highScore: game.highScores.value,
                                    difficulty: game.gameDifficulty.value),
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
