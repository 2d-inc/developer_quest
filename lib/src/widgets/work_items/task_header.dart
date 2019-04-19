import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/work_items/skill_dot.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';

/// A header for [Task] indicating the rewarded coin and skills 
/// necessary to work on the task.
class TaskHeader extends StatelessWidget {
  final TaskBlueprint blueprint;
  const TaskHeader(this.blueprint);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          child: const FlareActor("assets/flare/Coin.flr"),
        ),
        const SizedBox(width: 4),
        Text(
          blueprint.coinReward.toString(),
          style: contentSmallStyle,
        ),
        Expanded(child: Container()),
      ]..addAll(
          blueprint.skillsNeeded.map((Skill skill) => SkillDot(skill)).toList(),
        ),
    );
  }
}
