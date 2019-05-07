import 'package:dev_rpg/src/rpg_layout_builder.dart';
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
    return RpgLayoutBuilder(builder: (context, layout) {
      double scale = layout == RpgLayout.ultrawide ? 1.25 : 1.0;
      return Row(
        children: [
          Container(
            width: 20 * scale,
            height: 20 * scale,
            child: const FlareActor('assets/flare/Coin.flr'),
          ),
          const SizedBox(width: 4),
          Text(blueprint.coinReward.toString(),
              style: contentSmallStyle.apply(fontSizeFactor: scale)),
          Expanded(child: Container()),
          for (Skill skill in blueprint.skillsNeeded) SkillDot(skill)
        ],
      );
    });
  }
}
