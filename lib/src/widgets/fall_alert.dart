import 'package:flutter/material.dart';

class FallAlert extends StatelessWidget {
  const FallAlert(
  {
    super.key,
    required this.fallAlertText,
  });
  final String fallAlertText;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -0.4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            fallAlertText.toUpperCase(),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
