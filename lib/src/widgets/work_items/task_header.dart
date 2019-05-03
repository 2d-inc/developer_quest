import 'package:dev_rpg/src/game_screen/team_picker_modal.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';

/// A header for [Task] indicating the rewarded coin and skills
/// necessary to work on the task.

class CoinImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 20,
        height: 20,
        child: const FlareActor('assets/flare/Coin.flr'),
      ),
      const SizedBox(width: 4)
    ]);
  }
}

bool shipTask(Task task) {
  if (task.state == TaskState.completed) {
    task.shipFeature();
    return true;
  }
  return false;
}

void onAssigned(Task task, Set<Character> value) {
  if (value == null || value.isEmpty) return;
  if (task.isComplete) return;
  task.assignTeam(value.toList());
}

Future<Set<Character>> pickCharacters(BuildContext context, Task task) async {
  return showModalBottomSheet<Set<Character>>(
    context: context,
    builder: (context) => TeamPickerModal(task),
  );
}
