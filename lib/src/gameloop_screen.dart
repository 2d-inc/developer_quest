import 'package:dev_rpg/src/gameloop_screen/list_item.dart';
import 'package:dev_rpg/src/shared_state/game/countdown_clock.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:flutter/material.dart';

class GameloopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Provide<CountdownClock>(
          builder: (context, child, countdown) =>
              Text("${countdown.remainingTime.inSeconds}s"),
        ),
      ),
      body: Provide<TaskPool>(
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
      ),
    );
  }
}
