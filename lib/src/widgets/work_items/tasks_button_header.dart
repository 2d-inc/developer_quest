import 'package:dev_rpg/src/game_screen/add_task_button.dart';
import 'package:dev_rpg/src/game_screen/bug_picker_modal.dart';
import 'package:dev_rpg/src/game_screen/project_picker_modal.dart';
import 'package:dev_rpg/src/shared_state/game/bug.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This is a header providing two buttons, one for selecting tasks and another
/// for selecting active bugs to add to the working list.
class TasksButtonHeader extends StatelessWidget {
  final TaskPool taskPool;
  const TasksButtonHeader({this.taskPool});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
      child: Row(
        children: [
          Expanded(
            child: AddTaskButton(
              "Tasks",
              key: const Key('add_task'),
              count: taskPool.availableTasks.length,
              icon: Icons.add,
              color: const Color(0xff5472ee),
              onPressed: () async {
                var project = await showModalBottomSheet<TaskBlueprint>(
                  context: context,
                  builder: (context) => ProjectPickerModal(),
                );
                if (project != null) {
                  Provider.of<TaskPool>(context, listen: false)
                      .startTask(project);
                }
              },
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: AddTaskButton(
              "Bugs",
              count: taskPool.availableBugs.length,
              icon: Icons.bug_report,
              color: const Color(0xffeb2875),
              onPressed: () async {
                var bug = await showModalBottomSheet<Bug>(
                  context: context,
                  builder: (context) => BugPickerModal(),
                );
                if (bug != null) {
                  Provider.of<TaskPool>(context, listen: false)
                      .addWorkItem(bug);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
