import 'package:doodle_maze/src/widgets/game_app.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

Future<void> main() async {
  // Init hive to store High Scores
  await Hive.initFlutter();
  await Hive.openBox("highScore");
  // Game app handles the flame game initialization
  runApp(const GameApp());
}
