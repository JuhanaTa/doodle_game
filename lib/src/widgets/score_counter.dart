import 'package:flutter/material.dart';

class ScoreCounter extends StatelessWidget {
  const ScoreCounter(
      {super.key,
      required this.currentScore,
      required this.highScore,
      required this.difficulty});

  final ValueNotifier<int> currentScore;
  final Map<int, int> highScore;
  final int difficulty;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -1),
      padding: EdgeInsets.all(16),
      child: ValueListenableBuilder<int>(
        valueListenable: currentScore,
        builder: (context, currentScore, child) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  difficulty == 3
                      ? "Level: Hard".toUpperCase()
                      : difficulty == 2
                          ? "Level: Medium".toUpperCase()
                          : "Level: Easy".toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
                const SizedBox(height: 8, width: 0),
                Text(
                  'Current Score: $currentScore'.toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
                const SizedBox(height: 8, width: 0),
                Text(
                  'High Score: ${highScore[difficulty] ?? 0 }'.toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
              ]);
        },
      ),
    );
  }
}
