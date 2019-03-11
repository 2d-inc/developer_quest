import 'package:dev_rpg/src/game_screen/prowess_badge.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/npc_pool.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Present a list of [Npc]s for the player to choose from.
class TeamPickerModal extends StatefulWidget {
  final WorkItem workItem;

  const TeamPickerModal(this.workItem);

  @override
  TeamPickerModalState createState() {
    return TeamPickerModalState(workItem.assignedTeam);
  }
}

class TeamPickerModalState extends State<TeamPickerModal> {
  final Set<Npc> _selected;

  TeamPickerModalState(Iterable<Npc> initialTeam)
      : _selected = Set<Npc>.from(initialTeam ?? <Npc>[]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Pick team for "${widget.workItem.name}"'),
          Expanded(
            child: Consumer<NpcPool>(
              builder: (context, npcPool) {
                return _NpcDataTable(
                    pool: npcPool,
                    selected: _selected,
                    onToggleSelect: _toggleNpcSelected);
              },
            ),
          ),
          Container(
            child: ButtonBar(
              children: [
                FlatButton(
                    onPressed: () => Navigator.pop(context, _selected),
                    child: const Text('OK')),
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _toggleNpcSelected(Npc npc, bool selected) {
    setState(() {
      if (selected) {
        _selected.add(npc);
      } else {
        _selected.remove(npc);
      }
    });
  }
}

class _NpcDataTable extends StatelessWidget {
  final Set<Npc> selected;

  final NpcPool pool;

  final void Function(Npc npc, bool selected) onToggleSelect;

  const _NpcDataTable({
    @required this.selected,
    Key key,
    this.onToggleSelect,
    this.pool,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var npcs = pool.children
        .where((npc) => npc.isHired && (!npc.isBusy || selected.contains(npc)));

    var rows = npcs.map((npc) {
      return DataRow(
        selected: selected.contains(npc),
        onSelectChanged: (selected) => onToggleSelect(npc, selected),
        cells: [
          DataCell(
            Row(
              children: [
                Text(npc.name),
                Expanded(child: ProwessBadge(npc.prowess)),
              ],
            ),
          ),
        ],
      );
    });

    return DataTable(
      columns: const [DataColumn(label: Text('Name'))],
      rows: rows.toList(growable: false),
    );
  }
}
