import 'package:dev_rpg/src/game_screen/team_picker_modal.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/flare/work_team.dart';
import 'package:dev_rpg/src/widgets/prowess_progress.dart';
import 'package:dev_rpg/src/widgets/work_items/boost_indicator.dart';
import 'package:flutter/material.dart';

/// Shared containing widget for [WorkItem] (bug/task) styling. Handles assignment of [WorkItem]
/// to a set of [Npc]s and shows progress as work is done.
class WorkListItem extends StatefulWidget {
  final Widget button;
  final String coinReward;
  final bool isExpanded;
  final Widget heading;
  final Color progressColor;
  final WorkItem workItem;

  const WorkListItem(
      {this.workItem,
      this.button,
      this.coinReward,
      this.isExpanded = true,
      this.heading,
      this.progressColor});

  @override
  _WorkListItemState createState() => _WorkListItemState();
}

class _WorkListItemState extends State<WorkListItem> {
  bool showTapHint;
  final BoostController _boostController = BoostController();

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
  void initState() {
    super.initState();
    showTapHint = !widget.workItem.isComplete;
  }

  void _boostProgress(WorkItem item) {
    if (item.addBoost()) {
      setState(() {
        showTapHint = false;
      });

      _boostController.showIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    var workItem = widget.workItem;

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
              onTap: () => _boostProgress(workItem),
              child: AnimatedContainer(
                height: widget.isExpanded ? 140 : 0,
                duration: const Duration(milliseconds: 100),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9.0),
                      topRight: Radius.circular(9.0)),
                  color: Color(0xFF2D344E),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(9.0),
                              topRight: Radius.circular(9.0)),
                          child: Stack(
                            children: [
                              WorkTeam(
                                  skillsNeeded: workItem.skillsNeeded,
                                  isComplete: workItem.isComplete,
                                  team: workItem.assignedTeam),
                              showTapHint ? TapHint() : Container(),
                              Positioned.fill(
                                  child: BoostIndicator(_boostController))
                            ],
                          ),
                        ),
                      ),
                    ),
                    ProwessProgress(
                        color: widget.progressColor,
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
                          widget.heading,
                          const SizedBox(height: 12),
                          Text(workItem.name,
                              style: widget.isExpanded
                                  ? contentStyle
                                  : contentStyle.apply(color: disabledColor))
                        ],
                      ),
                    ),
                  ),
                ),
                widget.button ?? Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// A visual indicator that a region can be tapped on.
class TapHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: Container(
          width: 78.0,
          height: 78.0,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(84, 114, 239, 0.32)),
        ),
      ),
      Center(
        child: Container(
          width: 42.0,
          height: 42.0,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Color.fromRGBO(0, 152, 255, 1.0)),
        ),
      ),
      Center(
          child: Text("TAP",
              style: buttonTextStyle.apply(
                  fontSizeDelta: -4, color: Colors.white))),
    ]);
  }
}
