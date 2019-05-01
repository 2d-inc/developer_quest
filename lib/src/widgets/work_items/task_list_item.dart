import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dev_rpg/src/game_screen/team_picker_modal.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/work_items/team_progress_indicator.dart';
import 'package:dev_rpg/src/widgets/work_items/task_header.dart';

/// Displays a [Task] that can be tapped on to assign it to a team.
/// The task can also be tapped on to award points once it is completed.
class TaskListItem extends StatelessWidget {
  BoxDecoration get taskListItemDecoration => BoxDecoration(
        boxShadow: themeTaskShadow,
        borderRadius: const BorderRadius.all(Radius.circular(9.0)),
        color: Colors.white,
      );

  Future<void> _handleTap(BuildContext context, Task task) async {
    if (_shipTask(task)) {
      return;
    }
    Set<Character> characters = await _pickCharacters(context, task);
    _onAssigned(task, characters);
  }

  List<Widget> _getSpacedHeading(Task task) {
    Widget heading = task.state != TaskState.rewarded
        ? TaskHeader(task.blueprint)
        : const Icon(Icons.check_circle, color: disabledColor);
    return [
      heading,
      const SizedBox(height: 12.0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Task task = Provider.of<WorkItem>(context) as Task;
    bool isExpanded = task.isBeingWorkedOn || task.state == TaskState.completed;
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
      child: Container(
        decoration: taskListItemDecoration,
        child: TransparentMaterial(
          child: InkWell(
            onTap: () => _handleTap(context, task),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ..._getSpacedHeading(task),
                  Text(
                    task.name,
                    style: contentStyle,
                  ),
                  TeamProgressIndicator(
                    isExpanded: isExpanded,
                    task: task,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool _shipTask(Task task) {
  if (task.state == TaskState.completed) {
    task.shipFeature();
    return true;
  }
  return false;
}

void _onAssigned(Task task, Set<Character> value) {
  if (value == null || value.isEmpty) return;
  if (task.isComplete) return;
  task.assignTeam(value.toList());
}

Future<Set<Character>> _pickCharacters(BuildContext context, Task task) async {
  return showModalBottomSheet<Set<Character>>(
    context: context,
    builder: (context) => TeamPickerModal(task),
  );
}
