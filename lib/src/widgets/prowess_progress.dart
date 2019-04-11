import 'package:flutter/material.dart';

/// A progress bar with rounded corners and custom colors.
class ProwessProgress extends StatelessWidget {
  const ProwessProgress({@required this.progress, Key key, this.color})
      : super(key: key);

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: Container(
            height: 7,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.06),
                borderRadius: BorderRadius.circular(3.5)),
          ),
        ),
        FractionallySizedBox(
          widthFactor: progress,
          child: Container(
            height: 7,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3.5)),
          ),
        )
      ],
    );
  }
}
