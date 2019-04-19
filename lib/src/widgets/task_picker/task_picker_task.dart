import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/work_items/task_header.dart';
import 'package:flutter/material.dart';

class TaskPickerTask extends StatelessWidget {
  final TaskBlueprint blueprint;
  final List<bool> lines;
  final bool hasNextSibling;
  final bool hasNextChild;
  const TaskPickerTask(
      {this.blueprint,
      this.hasNextSibling = false,
      this.hasNextChild = false,
      this.lines});

  static const double height = 95;
  static const double dashWidth = 10;
  static const double halfLineHeight = 39;
  static const double bottomPadding = 15;

  @override
  Widget build(BuildContext context) {
    List<Widget> lineWidgets = [];
    for (int i = 0; i < lines.length; i++) {
      if (!lines[i]) {
        continue;
      }

      bool isLast = i == lines.length - 1;
      double lineHeight =
          i > 0 && isLast && !hasNextSibling ? halfLineHeight : height;
      lineWidgets.add(Positioned.fromRect(
        rect: Rect.fromLTWH(26.0 + i * 20, 0.0, 2, lineHeight),
        child: SizedOverflowBox(
          size: const Size.fromHeight(0),
          child: Container(color: treeLineColor),
        ),
      ));

      if (isLast && hasNextChild) {
        lineWidgets.add(Positioned.fromRect(
          rect: Rect.fromLTWH(
              26.0 + (i + 1) * 20, height - bottomPadding, 2, lineHeight),
          child: SizedOverflowBox(
            size: const Size.fromHeight(0),
            child: Container(color: treeLineColor),
          ),
        ));
      }
    }
    double left = 26.0 + (lines.length - 1) * 20;
    return SizedBox(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned.fromRect(
            rect: Rect.fromLTWH(left, halfLineHeight, dashWidth, 2),
            child: SizedOverflowBox(
              size: const Size.fromHeight(0),
              child: Container(color: treeLineColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: left + dashWidth, bottom: bottomPadding, right: 16),
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.03),
                      offset: Offset(0.0, 10.0),
                      blurRadius: 10,
                      spreadRadius: 0),
                ],
                borderRadius: BorderRadius.all(Radius.circular(9)),
                color: Colors.white,
              ),
			  child: TaskHeader(blueprint)
            ),
          )
        ]..addAll(lineWidgets),
      ),
    );
  }
}
