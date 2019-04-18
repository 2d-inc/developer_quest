import 'package:dev_rpg/src/game_screen/npc_style.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/widgets/flare/hiring_bust.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Widget that shows the team that is actively working on a work item.
class WorkTeam extends StatefulWidget {
  final List<Npc> team;
  final List<Skill> skillsNeeded;
  final bool isComplete;
  const WorkTeam({this.skillsNeeded, this.team, this.isComplete});
  @override
  _WorkTeamState createState() => _WorkTeamState();
}

/// A helper to store the animation state to display for the Npc
/// in the [WorkTeam] widget.
class _WorkTeamMember {
  final NpcStyle style;
  HiringBustState state;

  _WorkTeamMember(this.style, this.state);
}

class _WorkTeamState extends State<WorkTeam> {
  final List<_WorkTeamMember> _workTeam = [];
  @override
  void didUpdateWidget(WorkTeam oldWidget) {
    setState(updateNpcStyles);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    updateNpcStyles();
    super.initState();
  }

  void updateNpcStyles() {
    if (widget?.team == null) {
      if (widget.isComplete) {
        for (final _WorkTeamMember member in _workTeam) {
          member.state = HiringBustState.success;
        }
      }
      return;
    }
    _workTeam.clear();
    for (final Npc npc in widget.team) {
      NpcStyle style = NpcStyle.from(npc);
      if (style == null) {
        continue;
      }

      _workTeam.add(_WorkTeamMember(
          style,
          widget.isComplete
              ? HiringBustState.success
              : npc.contributes(widget.skillsNeeded)
                  ? HiringBustState.working
                  : HiringBustState.hired));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: _workTeam.map((member) {
          return Container(
              width: 71,
              height: 71,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromRGBO(69, 69, 82, 1.0),
              ),
              child: HiringBust(
                filename: member.style.flare,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                hiringState: member.state,
                isPlaying: true,
              ));
        }).toList());
  }
}
