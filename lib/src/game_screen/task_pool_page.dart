import 'package:dev_rpg/src/game_screen/add_task_button.dart';
import 'package:dev_rpg/src/game_screen/project_picker_modal.dart';
import 'package:dev_rpg/src/game_screen/task_list_item.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a list of the [Task]s the player has interacted with.
/// These are [Task]s that have been added into the game, are being
/// actively worked on, or have been completed and/or archived.
class TaskPoolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Consumer<TaskPool>(
            builder: (context, taskPool) {
              final workItems = taskPool.tasks
                  .cast<WorkItem>()
                  .followedBy(taskPool.bugs)
                  .followedBy(taskPool.completedTasks)
                  .followedBy(taskPool.archivedTasks)
                  .toList(growable: false);

              return ListView.builder(
                padding: const EdgeInsets.only(top: 110),
                itemCount: workItems.length,
                itemBuilder: (context, index) {
                  WorkItem item = workItems[index];

                  return ChangeNotifierProvider<WorkItem>(
                    notifier: item,
                    key: ValueKey(item),
                    child: TaskListItem(),
                  );
                },
              );
            },
          ),
        ),
        Positioned.fill(
          left: 20.0,
          right: 20.0,
          top: 50.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Consumer<TaskPool>(
                builder: (context, taskPool) {
                  return Row(
                    children: [
                      Expanded(
                        child: AddTaskButton(
                          "Tasks",
                          count: taskPool.availableTasks.length,
                          icon: Icons.add,
                          color: const Color(0xff5472ee),
                          onPressed: () async {
                            var project =
                                await showModalBottomSheet<TaskBlueprint>(
                              context: context,
                              builder: (context) => ProjectPickerModal(),
                            );
                            if (project == null) return;
                            Provider.of<TaskPool>(context, listen: false)
                                .startTask(project);
                          },
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      const Expanded(
                        child: AddTaskButton(
                          "Bugs",
                          count: 3,
                          icon: Icons.bug_report,
                          color: Color(0xffeb2875),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
