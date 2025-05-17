import 'package:flutter/material.dart';

class GameEndingScreen extends StatelessWidget {
  const GameEndingScreen(this.handleStartGame, this.handleLevelScreen,
      {super.key,
      required this.gameEndStatus,
      required this.gameEndDesc,
      required this.highScore,
      required this.difficulty});
  final String gameEndStatus;
  final String gameEndDesc;
  final Map<int, int> highScore;
  final int difficulty;
  final Function(int) handleStartGame;
  final Function() handleLevelScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -0.15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            gameEndStatus,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            gameEndDesc,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            "High Score: ${highScore[difficulty] ?? 0 }",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: () => handleStartGame(0),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, padding: EdgeInsets.all(20)),
              child: Text(
                'Try again',
                style: Theme.of(context).textTheme.headlineLarge,
              )),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: handleLevelScreen,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, padding: EdgeInsets.all(20)),
              child: Text(
                'Level Selection',
                style: Theme.of(context).textTheme.headlineLarge,
              )),
        ],
      ),
    );
  }
}
