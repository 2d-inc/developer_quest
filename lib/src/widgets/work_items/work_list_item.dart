import 'dart:async';

import 'package:dev_rpg/src/game_screen/team_picker_modal.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/flare/work_team.dart';
import 'package:dev_rpg/src/widgets/work_items/work_list_progress.dart';
import 'package:flutter/material.dart';

/// A callback that can be provided to the WorkListItem to provide specialized
/// logic when tapping on the entire task.
typedef HandleTapCallback = bool Function();

/// Shared containing widget for [WorkItem] (bug/task) styling. Handles assignment of [WorkItem]
/// to a set of [Character]s and shows progress as work is done.
class WorkListItem extends StatelessWidget {
  final bool isExpanded;
  final Widget heading;
  final Color progressColor;
  final WorkItem workItem;
  final HandleTapCallback handleTap;

  const WorkListItem({
    this.workItem,
    this.isExpanded = true,
    this.heading,
    this.progressColor,
    this.handleTap,
  });

  BoxDecoration get workListItemDecoration => BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: const Offset(0.0, 10.0),
              blurRadius: 10.0,
              spreadRadius: 0.0),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(9.0)),
        color: Colors.black,
      );

  Future<void> _handleTap(BuildContext context, WorkItem workItem) async {
    if (handleTap != null && handleTap()) {
      return;
    }
    var characters = await showModalBottomSheet<Set<Character>>(
      context: context,
      builder: (context) => TeamPickerModal(workItem),
    );
    _onAssigned(workItem, characters);
  }

  void _onAssigned(WorkItem workItem, Set<Character> value) {
    if (value == null || value.isEmpty) return;
    if (workItem.isComplete) return;
    workItem.assignTeam(value.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
      child: Container(
        decoration: workListItemDecoration,
        child: Material(
          type: MaterialType.transparency,
          borderRadius: const BorderRadius.all(Radius.circular(9.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              workItem.name,
            ),
          ),
        ),
      ),
    );
  }
}

class TeamProgressIndicator extends StatelessWidget {
  const TeamProgressIndicator({
    this.workItem,
    this.isExpanded,
    this.progressColor,
  });

  final WorkItem workItem;
  final bool isExpanded;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    return !isExpanded
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 11),
              WorkListProgress(
                progressColor: progressColor,
                workItem: workItem,
              ),
              WorkTeam(
                team: workItem.assignedTeam,
                skillsNeeded: workItem.skillsNeeded,
                isComplete: workItem.isComplete,
              ),
            ],
          );
  }
}
