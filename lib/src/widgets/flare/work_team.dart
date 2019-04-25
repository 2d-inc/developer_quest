import 'package:dev_rpg/src/game_screen/character_style.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/widgets/flare/hiring_bust.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Widget that shows the team that is actively working on a work item.
class WorkTeam extends StatefulWidget {
  final List<Character> team;
  final List<Skill> skillsNeeded;
  final bool isComplete;
  const WorkTeam({this.skillsNeeded, this.team, this.isComplete});
  @override
  _WorkTeamState createState() => _WorkTeamState();
}

/// A helper to store the animation state to display for the Character
/// in the [WorkTeam] widget.
class _WorkTeamMember {
  final CharacterStyle style;
  HiringBustState state;

  _WorkTeamMember(this.style, this.state);
}

class _WorkTeamState extends State<WorkTeam> {
  final List<_WorkTeamMember> _workTeam = [];
  @override
  void didUpdateWidget(WorkTeam oldWidget) {
    setState(updateCharacterStyles);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    updateCharacterStyles();
    super.initState();
  }

  void updateCharacterStyles() {
    if (widget?.team == null) {
      if (widget.isComplete) {
        for (final _WorkTeamMember member in _workTeam) {
          member.state = HiringBustState.success;
        }
      }
      return;
    }
    _workTeam.clear();
    for (final Character character in widget.team) {
      CharacterStyle style = CharacterStyle.from(character);
      if (style == null) {
        continue;
      }

      _workTeam.add(_WorkTeamMember(
          style,
          widget.isComplete
              ? HiringBustState.success
              : character.contributes(widget.skillsNeeded)
                  ? HiringBustState.working
                  : HiringBustState.hired));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: _workTeam.map((member) {
          return Container(
              width: 71,
              height: 71,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(69, 69, 82, 1),
              ),
              child: HiringBust(
                filename: member.style.flare,
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
                hiringState: member.state,
                isPlaying: true,
              ));
        }).toList());
  }
}
