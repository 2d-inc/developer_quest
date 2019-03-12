import 'package:dev_rpg/src/game_screen/prowess_badge.dart';
import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/npc_pool.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Present a list of [Npc]s for the player to choose from.
class TeamPickerModal extends StatefulWidget {
  final WorkItem workItem;

  TeamPickerModal(this.workItem);

  @override
  TeamPickerModalState createState() {
    return new TeamPickerModalState(workItem.assignedTeam);
  }
}

class TeamPickerModalState extends State<TeamPickerModal> {
  final Set<Npc> _selected;

  TeamPickerModalState(Iterable<Npc> initialTeam)
      : _selected = Set<Npc>.from(initialTeam ?? []);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Text('Pick team for "${widget.workItem.name}"'),
          Wrap(
            alignment: WrapAlignment.end,
            children: widget.workItem.skillsNeeded
                .map((Skill skill) => SkillBadge(skill))
                .toList(),
          ),
          SizedBox(height: 16),
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
    Key key,
    @required selected,
    this.onToggleSelect,
    this.pool,
  })  : selected = selected,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var npcs = pool.where((npc) => npc.isHired);

    var rows = npcs.map((npc) {
      var selectable = !npc.isBusy || selected.contains(npc);
      return DataRow(
        selected: selected.contains(npc),
        onSelectChanged:
            selectable ? (selected) => onToggleSelect(npc, selected) : null,
        cells: [
          DataCell(
            Text(npc.name,
                style: TextStyle(color: selectable ? null : Colors.grey)),
          ),
          DataCell(ProwessBadge(npc.prowess)),
        ],
      );
    });

    return DataTable(
      columns: [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Skills')),
      ],
      rows: rows.toList(growable: false),
    );
  }
}
