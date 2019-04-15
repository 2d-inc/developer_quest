import 'dart:math';

import 'package:dev_rpg/src/game_screen/npc_style.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:flare_flutter/flare_actor.dart';
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
  String animation;

  _WorkTeamMember(this.style, this.animation);
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
          member.animation = "success";
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
              ? "success"
              : npc.contributes(widget.skillsNeeded) ? "working" : "idle"));
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthFactor = 1.0 / max(2.0, _workTeam.length);
    return Stack(
      children: _workTeam.map((member) {
        return Align(
          alignment: Alignment(
              -1.0 +
                  (_workTeam.indexOf(member) /
                      max(1, _workTeam.length - 1) *
                      2.0),
              1.0),
          child: FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 1.0,
            widthFactor: widthFactor,
            child: FlareActor(
              member.style.flare,
              alignment: Alignment.bottomCenter,
              fit: BoxFit.cover,
              shouldClip: false,
              animation: member.animation,
            ),
          ),
        );
      }).toList(),
    );
  }
}
