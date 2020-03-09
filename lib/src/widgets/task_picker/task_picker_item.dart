import 'package:dev_rpg/src/rpg_layout_builder.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/work_items/task_header.dart';
import 'package:flutter/material.dart';

// The display state for a widget in the task picker tree
enum TaskDisplay { complete, available, locked }

/// Task list item in the task picker. This widget is responsible for also
/// drawing the set of lines in its row to build up a connected tree.
class TaskPickerItem extends StatelessWidget {
  final TaskBlueprint blueprint;
  final List<bool> lines;
  final bool hasNextSibling;
  final bool hasNextChild;
  final TaskDisplay display;

  const TaskPickerItem({
    this.blueprint,
    this.hasNextSibling = false,
    this.hasNextChild = false,
    this.lines,
    this.display,
  });

  static const double _height = 95;
  static const double _dashWidth = 10;
  static const double _halfLineHeight = 39;
  static const double _bottomPadding = 15;
  static const double _leftPadding = 26;
  static const double _lineSpacing = 20;
  static const double _lineThickness = 2;

  @override
  Widget build(BuildContext context) {
    return RpgLayoutBuilder(
      builder: (context, layout) {
        double scale = layout == RpgLayout.ultrawide ? 1.25 : 1;
        double height = layout == RpgLayout.ultrawide ? _height * 1.1 : _height;
        // Build up the vertical lines that show the connections in the tree.
        List<Widget> lineWidgets = [];
        for (int i = 0; i < lines.length; i++) {
          if (!lines[i]) {
            continue;
          }

          bool isLast = i == lines.length - 1;
          double lineHeight =
              i > 0 && isLast && !hasNextSibling ? _halfLineHeight : height;
          lineWidgets.add(Positioned.fromRect(
            rect: Rect.fromLTWH(
                _leftPadding + i * _lineSpacing, 0, _lineThickness, lineHeight),
            child: SizedOverflowBox(
              size: const Size.fromHeight(0),
              child: Container(color: treeLineColor),
            ),
          ));

          if (isLast && hasNextChild) {
            lineWidgets.add(Positioned.fromRect(
              rect: Rect.fromLTWH(_leftPadding + (i + 1) * _lineSpacing,
                  height - _bottomPadding, _lineThickness, lineHeight),
              child: SizedOverflowBox(
                size: const Size.fromHeight(0),
                child: Container(color: treeLineColor),
              ),
            ));
          }
        }
        double left = _leftPadding + (lines.length - 1) * _lineSpacing;
        return SizedBox(
          height: height,
          child: Stack(
            children: [
              Positioned.fromRect(
                rect: Rect.fromLTWH(
                    left, _halfLineHeight, _dashWidth, _lineThickness),
                child: SizedOverflowBox(
                  size: const Size.fromHeight(0),
                  child: Container(color: treeLineColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: left + _dashWidth, bottom: _bottomPadding, right: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                  ),
                  child: InkWell(
                    onTap: display != TaskDisplay.available
                        ? null
                        : () => Navigator.pop(context, blueprint),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.03),
                              offset: Offset(0, 10),
                              blurRadius: 10,
                              spreadRadius: 0),
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(9)),
                        color: display == TaskDisplay.available
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                      child: display == TaskDisplay.available
                          ? _TaskDisplayAvailable(blueprint, scale: scale)
                          : display == TaskDisplay.locked
                              ? _TaskDisplayLocked(blueprint, scale: scale)
                              : _TaskDisplayCompleted(blueprint, scale: scale),
                    ),
                  ),
                ),
              ),
              ...lineWidgets
            ],
          ),
        );
      },
    );
  }
}

/// Widget for available task in task picker tree
class _TaskDisplayAvailable extends StatelessWidget {
  final TaskBlueprint blueprint;
  final double scale;
  const _TaskDisplayAvailable(this.blueprint, {this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TaskHeader(blueprint),
        const SizedBox(height: 10),
        Text(blueprint.name,
            overflow: TextOverflow.ellipsis,
            style: contentStyle.apply(fontSizeFactor: scale))
      ],
    );
  }
}

/// Widget for locked task in task picker tree
class _TaskDisplayLocked extends StatelessWidget {
  final TaskBlueprint blueprint;
  final double scale;
  const _TaskDisplayLocked(this.blueprint, {this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.lock_outline,
            color: disabledColor.withOpacity(0.25), size: 20 * scale),
        const SizedBox(height: 10),
        Text(blueprint.name,
            overflow: TextOverflow.ellipsis,
            style: contentStyle.apply(
                color: contentColor.withOpacity(0.25), fontSizeFactor: scale))
      ],
    );
  }
}

/// Widget for completed task in task picker tree
class _TaskDisplayCompleted extends StatelessWidget {
  final TaskBlueprint blueprint;
  final double scale;
  const _TaskDisplayCompleted(this.blueprint, {this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle,
            color: disabledColor.withOpacity(0.25), size: 20 * scale),
        const SizedBox(height: 10),
        Text(blueprint.name,
            overflow: TextOverflow.ellipsis,
            style: contentStyle.apply(
                color: contentColor.withOpacity(0.25), fontSizeFactor: scale))
      ],
    );
  }
}
