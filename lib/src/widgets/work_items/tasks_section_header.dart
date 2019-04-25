import 'package:dev_rpg/src/style.dart';
import 'package:flutter/material.dart';

/// This is a simple text header for the tasks list.
class TasksSectionHeader extends SliverPersistentHeaderDelegate {
  final String title;
  const TasksSectionHeader(this.title);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        title,
        style: buttonTextStyle.apply(
            fontSizeDelta: -4, color: secondaryContentColor),
      ),
    );
  }

  @override
  double get maxExtent => 45;

  @override
  double get minExtent => 45;

  @override
  bool shouldRebuild(TasksSectionHeader oldDelegate) {
    return title != oldDelegate.title;
  }
}
