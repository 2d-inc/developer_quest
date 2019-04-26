import 'package:flutter/material.dart';

import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/widgets/flare/work_team.dart';
import 'package:dev_rpg/src/widgets/work_items/work_list_progress.dart';

class TeamProgressIndicator extends StatelessWidget {
  const TeamProgressIndicator({
    this.task,
    this.isExpanded,
    this.progressColor = const Color.fromRGBO(0, 152, 255, 1.0),
  });

  final Task task;
  final bool isExpanded;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    return !isExpanded
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 11),
              WorkListProgress(
                progressColor: progressColor,
                workItem: task,
              ),
              WorkTeam(
                team: task.assignedTeam,
                skillsNeeded: task.skillsNeeded,
                isComplete: task.isComplete,
              ),
            ],
          );
  }
}
