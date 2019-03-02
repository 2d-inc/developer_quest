import 'package:dev_rpg/src/game_screen/task_list_item.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/project.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:flutter/material.dart';

class TaskPoolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();/*Provide<Project>(
      builder: (context, child, taskPool) {
        return ListView.builder(
          itemCount: taskPool.length,
          itemBuilder: (context, index) => ProviderNode(
                providers: Providers.withProviders({
                  Task: Provider<Task>.value(taskPool[index]),
                }),
                child: TaskListItem(
                  key: ValueKey(taskPool[index]),
                ),
              ),
        );
      },
    );*/
  }
}
