import 'package:dev_rpg/src/style.dart';
import 'package:flutter/material.dart';

/// This is a simple text header for the tasks list.
class TasksSectionHeader extends StatelessWidget {
  final String title;
  const TasksSectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        title,
        style: buttonTextStyle.apply(
            fontSizeDelta: -4, color: secondaryContentColor),
      ),
    );
  }
}
