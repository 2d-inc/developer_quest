import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:flutter/material.dart';

class TaskPickerTask extends StatelessWidget {
  final TaskBlueprint blueprint;
  final int indent;
  final bool hasNextSibling;
  final bool hasNextChild;
  const TaskPickerTask(
      {this.blueprint, this.hasNextSibling, this.hasNextChild, this.indent});

	static const double height = 95;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned.fromRect(
            rect: Rect.fromLTWH(26, 0.0, 2, height),
            child: SizedOverflowBox(
              size: const Size.fromHeight(0),
              child: Container(color: treeLineColor),
            ),
          ),
		  Positioned.fromRect(
            rect: Rect.fromLTWH(26, 39, 10, 2),
            child: SizedOverflowBox(
              size: const Size.fromHeight(0),
              child: Container(color: treeLineColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 38.0 + indent.toDouble() * 22.0, bottom: 15.0, right: 16),
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
            ),
          )
        ],
      ),
    );
  }
}
