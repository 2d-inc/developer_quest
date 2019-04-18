import 'package:dev_rpg/src/game_screen/prowess_badge.dart';
import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/character_pool.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Present a list of [Character]s for the player to choose from.
class TeamPickerModal extends StatefulWidget {
  final WorkItem workItem;

  const TeamPickerModal(this.workItem);

  @override
  TeamPickerModalState createState() {
    return TeamPickerModalState(workItem.assignedTeam);
  }
}

class TeamPickerModalState extends State<TeamPickerModal> {
  final Set<Character> _selected;

  TeamPickerModalState(Iterable<Character> initialTeam)
      : _selected = Set<Character>.from(initialTeam ?? <Character>[]);

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
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<CharacterPool>(
              builder: (context, characterPool) {
                return _CharacterDataTable(
                    pool: characterPool,
                    selected: _selected,
                    onToggleSelect: _toggleCharacterSelected);
              },
            ),
          ),
          Container(
            child: ButtonBar(
              children: [
                FlatButton(
                    key: const Key('team_pick_ok'),
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

  void _toggleCharacterSelected(Character character, bool selected) {
    setState(() {
      if (selected) {
        _selected.add(character);
      } else {
        _selected.remove(character);
      }
    });
  }
}

class _CharacterDataTable extends StatelessWidget {
  final Set<Character> selected;

  final CharacterPool pool;

  final void Function(Character character, bool selected) onToggleSelect;

  const _CharacterDataTable({
    @required this.selected,
    Key key,
    this.onToggleSelect,
    this.pool,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var characters = pool.children.where((c) => c.isHired);

    var rows = characters.map((character) {
      var selectable = !character.isBusy || selected.contains(character);
      return DataRow(
        selected: selected.contains(character),
        onSelectChanged: selectable
            ? (selected) => onToggleSelect(character, selected)
            : null,
        cells: [
          DataCell(
            Text(character.id,
                style: TextStyle(color: selectable ? null : Colors.grey)),
          ),
          DataCell(ProwessBadge(character.prowess)),
        ],
      );
    });

    return DataTable(
      columns: const [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Skills')),
      ],
      rows: rows.toList(growable: false),
    );
  }
}
