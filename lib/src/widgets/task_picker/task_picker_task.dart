import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/work_items/task_header.dart';
import 'package:flutter/material.dart';

enum TaskDisplayState { complete, available, locked }

class TaskPickerTask extends StatelessWidget {
  final TaskBlueprint blueprint;
  final List<bool> lines;
  final bool hasNextSibling;
  final bool hasNextChild;
  final TaskDisplayState display;

  const TaskPickerTask(
      {this.blueprint,
      this.hasNextSibling = false,
      this.hasNextChild = false,
      this.lines,
      this.display});

  static const double height = 95;
  static const double dashWidth = 10;
  static const double halfLineHeight = 39;
  static const double bottomPadding = 15;
  static const double leftPadding = 26;
  static const double lineSpacing = 20;
  static const double lineThickness = 2;

  @override
  Widget build(BuildContext context) {
    // Build up lines first.
    List<Widget> lineWidgets = [];
    for (int i = 0; i < lines.length; i++) {
      if (!lines[i]) {
        continue;
      }

      bool isLast = i == lines.length - 1;
      double lineHeight =
          i > 0 && isLast && !hasNextSibling ? halfLineHeight : height;
      lineWidgets.add(Positioned.fromRect(
        rect: Rect.fromLTWH(
            leftPadding + i * lineSpacing, 0.0, lineThickness, lineHeight),
        child: SizedOverflowBox(
          size: const Size.fromHeight(0),
          child: Container(color: treeLineColor),
        ),
      ));

      if (isLast && hasNextChild) {
        lineWidgets.add(Positioned.fromRect(
          rect: Rect.fromLTWH(leftPadding + (i + 1) * lineSpacing,
              height - bottomPadding, lineThickness, lineHeight),
          child: SizedOverflowBox(
            size: const Size.fromHeight(0),
            child: Container(color: treeLineColor),
          ),
        ));
      }
    }
    double left = leftPadding + (lines.length - 1) * lineSpacing;
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned.fromRect(
            rect: Rect.fromLTWH(left, halfLineHeight, dashWidth, lineThickness),
            child: SizedOverflowBox(
              size: const Size.fromHeight(0),
              child: Container(color: treeLineColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: left + dashWidth, bottom: bottomPadding, right: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
              ),
              child: InkWell(
                onTap: display != TaskDisplayState.available
                    ? null
                    : () => Navigator.pop(context, blueprint),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.03),
                          offset: Offset(0.0, 10.0),
                          blurRadius: 10,
                          spreadRadius: 0),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(9)),
                    color: display == TaskDisplayState.available
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                  child: display == TaskDisplayState.available
                      ? _TaskDisplayAvailable(blueprint)
                      : display == TaskDisplayState.locked
                          ? _TaskDisplayLocked(
                              blueprint,
                            )
                          : _TaskDisplayCompleted(blueprint),
                ),
              ),
            ),
          )
        ]..addAll(lineWidgets),
      ),
    );
  }
}

/// Widget for available task in task picker tree
class _TaskDisplayAvailable extends StatelessWidget {
  final TaskBlueprint blueprint;
  const _TaskDisplayAvailable(this.blueprint);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TaskHeader(blueprint),
        const SizedBox(height: 10),
        Text(blueprint.name, style: contentStyle)
      ],
    );
  }
}

/// Widget for locked task in task picker tree
class _TaskDisplayLocked extends StatelessWidget {
  final TaskBlueprint blueprint;
  const _TaskDisplayLocked(this.blueprint);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.lock_outline,
            color: disabledColor.withOpacity(0.25), size: 20),
        const SizedBox(height: 10),
        Text(blueprint.name,
            style: contentStyle.apply(color: contentColor.withOpacity(0.25)))
      ],
    );
  }
}

/// Widget for completed task in task picker tree
class _TaskDisplayCompleted extends StatelessWidget {
  final TaskBlueprint blueprint;
  const _TaskDisplayCompleted(this.blueprint);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle,
            color: disabledColor.withOpacity(0.25), size: 20),
        const SizedBox(height: 10),
        Text(blueprint.name,
            style: contentStyle.apply(color: contentColor.withOpacity(0.25)))
      ],
    );
  }
}
