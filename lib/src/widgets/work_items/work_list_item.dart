import 'package:dev_rpg/src/game_screen/team_picker_modal.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/flare/work_team.dart';
import 'package:dev_rpg/src/widgets/prowess_progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shared containing widget for [WorkItem] (bug/task) styling. Handles assignment of [WorkItem]
/// to a set of [Npc]s and shows progress as work is done.
class WorkListItem extends StatelessWidget {
  final Widget button;
  final String coinReward;
  final bool isExpanded;
  final Widget heading;
  final Color progressColor;
  const WorkListItem(
      {this.button,
      this.coinReward,
      this.isExpanded = true,
      this.heading,
      this.progressColor});

  Future<void> _handleTap(BuildContext context, WorkItem workItem) async {
    var npcs = await showDialog<Set<Npc>>(
      context: context,
      builder: (context) => TeamPickerModal(workItem),
    );
    _onAssigned(workItem, npcs);
  }

  void _onAssigned(WorkItem workItem, Set<Npc> value) {
    if (value == null || value.isEmpty) return;
    if (workItem.isComplete) return;
    workItem.assignTeam(value.toList());
  }

  @override
  Widget build(BuildContext context) {
    var workItem = Provider.of<WorkItem>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  offset: const Offset(0.0, 10.0),
                  blurRadius: 10.0,
                  spreadRadius: 0.0),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(9.0)),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: workItem.addBoost,
              child: AnimatedContainer(
                height: isExpanded ? 140 : 0,
                duration: const Duration(milliseconds: 100),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9.0),
                      topRight: Radius.circular(9.0)),
                  color: Color(0xFF2D344E),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: WorkTeam(
                            alignment: Alignment.bottomLeft,
                            fit: BoxFit.contain,
                            team: workItem.assignedTeam),
                      ),
                    ),
                    ProwessProgress(
                        color: progressColor,
                        progress: workItem.percentComplete)
                  ],
                ),
              ),
            ),
            Stack(
              children: <Widget>[
                Material(
                  type: MaterialType.transparency,
                  borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _handleTap(context, workItem),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heading,
                          const SizedBox(height: 12),
                          Text(workItem.name,
                              style: isExpanded
                                  ? contentStyle
                                  : contentStyle.apply(color: disabledColor))
                        ],
                      ),
                    ),
                  ),
                ),
                button ?? Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}
