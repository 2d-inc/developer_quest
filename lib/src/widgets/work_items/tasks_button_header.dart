import 'package:dev_rpg/src/game_screen/task_buttons.dart';
import 'package:flutter/material.dart';
/// This is a header providing two buttons, one for selecting tasks and another
/// for selecting active bugs to add to the working list.
class TasksButtonHeader extends StatelessWidget {
  const TasksButtonHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Row(
        children: [
          TasksButton(),
          const SizedBox(width: 10),
          BugsButton(),
        ],
      ),
    );
  }
}
