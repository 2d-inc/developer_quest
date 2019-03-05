import 'package:dev_rpg/src/game_screen/project_picker_modal.dart';
import 'package:dev_rpg/src/game_screen/task_list_item.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:flutter/material.dart';

class TaskPoolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<TaskPool>(
      builder: (context, child, taskPool) {
        final tasks = taskPool.workingTasks
            .followedBy(taskPool.doneTasks)
            .toList(growable: false);
        return new Stack(
          children: <Widget>[
            Positioned.fill(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 110),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  Task item = tasks[index];

                  return ProviderNode(
                      providers: Providers.withProviders({
                        Task: Provider<Task>.value(item),
                      }),
                      child: TaskListItem());
                },
              ),
            ),
            new Positioned.fill(
              right: 20.0,
              top: 50.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                    elevation: 0.0,
                    child: new Icon(Icons.add),
                    onPressed: () async {
                      var project = await showModalBottomSheet<TaskBlueprint>(
                        context: context,
                        builder: (context) => ProjectPickerModal(),
                      );
                      if (project == null) return;
                      taskPool.startTask(project);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
