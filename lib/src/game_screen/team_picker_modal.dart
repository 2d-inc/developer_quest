import 'package:dev_rpg/src/game_screen/prowess_badge.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/npc_pool.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:flutter/material.dart';

class TeamPickerModal extends StatefulWidget {
  final Task task;

  TeamPickerModal(this.task);

  @override
  TeamPickerModalState createState() {
    return new TeamPickerModalState(task.assignedTeam);
  }
}

class TeamPickerModalState extends State<TeamPickerModal> {
  Set<Npc> _selected = Set<Npc>();

  TeamPickerModalState(Iterable<Npc> initialTeam)
      : _selected = Set<Npc>.from(initialTeam ?? []);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Pick team for "${widget.task.blueprint.name}"'),
          Expanded(
            child: Provide<NpcPool>(
              builder: (context, child, npcPool) {
                return DataTable(
                  columns: [
                    DataColumn(label: Text('Name')),
                  ],
                  rows: npcPool
                      .where((npc) =>
                          npc.isHired &&
                          (!npc.isBusy || _selected.contains(npc)))
                      .map((npc) => DataRow(
                            selected: _selected.contains(npc),
                            onSelectChanged: (selected) => setState(() {
                                  if (selected) {
                                    _selected.add(npc);
                                  } else {
                                    _selected.remove(npc);
                                  }
                                }),
                            cells: [
                              DataCell(Row(children: <Widget>[
                                Text(npc.name),
                                Expanded(child: ProwessBadge(npc.prowess))
                              ]))
                            ],
                          ))
                      .toList(growable: false),
                );
              },
            ),
          ),
          Container(
            child: ButtonBar(
              children: [
                FlatButton(
                    onPressed: () => Navigator.pop(context, _selected),
                    child: Text('OK')),
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
