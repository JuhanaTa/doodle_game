import 'package:flutter/material.dart';

class DifficultyCounter extends StatelessWidget {
  const DifficultyCounter({
    super.key,
    required this.difficulty
  });

  final ValueNotifier<int> difficulty;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: difficulty,
      builder: (context, difficulty, child) {
        return Column(
            //padding: const EdgeInsets.fromLTRB(12, 6, 12, 18),
            children: [
              Text(
                difficulty == 3 ? "Level: Hard".toUpperCase() : difficulty == 2 ? "Level: Medium".toUpperCase() : "Level: Easy".toUpperCase(),
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ]);
      },
    );
  }
}
