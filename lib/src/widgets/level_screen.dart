import 'package:flutter/material.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen(this.handleStartGame, {super.key, required this.highScore});
  final Function(int) handleStartGame;
  final Map<int, int> highScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -0.15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Definitely not Doodle Jump".toUpperCase(),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: () => handleStartGame(1),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, padding: EdgeInsets.all(20)),
              child: Text(
                'Level 1',
                style: Theme.of(context).textTheme.headlineLarge,
              )),
          const SizedBox(height: 8),
          Text(
            "Easy difficulty",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            "High Score: ${highScore[1] ?? 0}",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: () => handleStartGame(2),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, padding: EdgeInsets.all(20)),
              child: Text(
                'Level 2',
                style: Theme.of(context).textTheme.headlineLarge,
              )),
          const SizedBox(height: 8),
          Text(
            "Medium difficulty",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            "High Score: ${highScore[2] ?? 0}",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: () => handleStartGame(3),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, padding: EdgeInsets.all(20)),
              child: Text(
                'Level 3',
                style: Theme.of(context).textTheme.headlineLarge,
              )),
          const SizedBox(height: 8),
          Text(
            "Hard difficulty",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            "High Score: ${highScore[3] ?? 0}",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
