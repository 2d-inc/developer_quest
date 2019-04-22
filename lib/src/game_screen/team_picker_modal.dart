import 'package:dev_rpg/src/game_screen/character_style.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/character_pool.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/buttons/wide_button.dart';
import 'package:dev_rpg/src/widgets/flare/hiring_bust.dart';
import 'package:dev_rpg/src/widgets/flare/skill_icon.dart';
import 'package:dev_rpg/src/widgets/prowess_progress.dart';
import 'package:dev_rpg/src/widgets/skill_badge.dart';
import 'package:flare_flutter/flare_actor.dart';
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

  static const EdgeInsets horizontalPadding =
      EdgeInsets.symmetric(horizontal: 15);

  TeamPickerModalState(Iterable<Character> initialTeam)
      : _selected = Set<Character>.from(initialTeam ?? <Character>[]);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: Container(
        color: modalBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: horizontalPadding,
              child: Text(widget.workItem.name, style: contentLargeStyle),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: horizontalPadding,
              child: Text("SKILLS REQUIRED:",
                  style: buttonTextStyle.apply(
                      fontSizeDelta: -4, color: secondaryContentColor)),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: horizontalPadding,
              child: Row(
                  children: widget.workItem.skillsNeeded
                      .map((skill) => SkillBadge(skill))
                      .toList()),
            ),
            Expanded(
              child: Consumer<CharacterPool>(
                builder: (context, characterPool) {
                  var characters = characterPool.children
                      .where((c) => c.isHired && !c.isBusy)
                      .toList();
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: horizontalPadding,
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        var character = characters[index];
                        return TeamPickerItem(
                          character,
                          isSelected: _selected.contains(character),
                          toggleSelection: _toggleCharacterSelected,
                        );
                      });
                },
              ),
            ),
            Padding(
              padding: horizontalPadding.add(EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom)),
              child: WideButton(
                  onPressed: () {},
                  paddingTweak: const EdgeInsets.only(right: -7.0),
                  background: _selected.isNotEmpty
                      ? const Color.fromRGBO(84, 114, 239, 1.0)
                      : contentColor.withOpacity(0.1),
                  child: Text("ASSIGN TEAM",
                      style: buttonTextStyle.apply(
                        color: _selected.isNotEmpty
                            ? Colors.white
                            : contentColor.withOpacity(0.25),
                      ))),
            )
          ],
        ),
      ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Column(
//         children: [
//           Text('Pick team for "${widget.workItem.name}"'),
//           Wrap(
//             alignment: WrapAlignment.end,
//             children: widget.workItem.skillsNeeded
//                 .map((Skill skill) => SkillBadge(skill))
//                 .toList(),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: Consumer<CharacterPool>(
//               builder: (context, characterPool) {
//                 return _CharacterDataTable(
//                     pool: characterPool,
//                     selected: _selected,
//                     onToggleSelect: _toggleCharacterSelected);
//               },
//             ),
//           ),
//           Container(
//             child: ButtonBar(
//               children: [
//                 FlatButton(
//                     key: const Key('team_pick_ok'),
//                     onPressed: () => Navigator.pop(context, _selected),
//                     child: const Text('OK')),
//                 FlatButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Cancel')),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

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

// class _CharacterDataTable extends StatelessWidget {
//   final Set<Character> selected;

//   final CharacterPool pool;

//   final void Function(Character character, bool selected) onToggleSelect;

//   const _CharacterDataTable({
//     @required this.selected,
//     Key key,
//     this.onToggleSelect,
//     this.pool,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var characters = pool.children.where((c) => c.isHired);

//     var rows = characters.map((character) {
//       var selectable = !character.isBusy || selected.contains(character);
//       return DataRow(
//         selected: selected.contains(character),
//         onSelectChanged: selectable
//             ? (selected) => onToggleSelect(character, selected)
//             : null,
//         cells: [
//           DataCell(
//             Text(character.id,
//                 style: TextStyle(color: selectable ? null : Colors.grey)),
//           ),
//           DataCell(ProwessBadge(character.prowess)),
//         ],
//       );
//     });

//     return DataTable(
//       columns: const [
//         DataColumn(label: Text('Name')),
//         DataColumn(label: Text('Skills')),
//       ],
//       rows: rows.toList(growable: false),
//     );
//   }
// }

class TeamPickerItem extends StatelessWidget {
  final Character character;
  final bool isSelected;
  final void Function(Character character, bool selected) toggleSelection;

  static const Duration animationDuration = Duration(milliseconds: 175);
  const TeamPickerItem(this.character,
      {this.isSelected = false, this.toggleSelection});

  @override
  Widget build(BuildContext context) {
    var characterStyle = CharacterStyle.from(character);

    return AnimatedPadding(
      padding: isSelected
          ? const EdgeInsets.only(top: 27, bottom: 50)
          : const EdgeInsets.only(top: 47, bottom: 30),
      duration: animationDuration,
      curve: Curves.easeInOut,
      child: InkWell(
        onTap: () => toggleSelection(character, !isSelected),
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: AnimatedContainer(
            duration: animationDuration,
            width: 103,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.17),
                    offset: const Offset(0.0, 10.0),
                    blurRadius: 10.0),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              color: isSelected
                  ? const Color.fromRGBO(84, 114, 239, 1.0)
                  : const Color.fromRGBO(69, 69, 82, 1.0),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: HiringBust(
                    filename: characterStyle.flare,
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                    hiringState: HiringBustState.hired,
                    isPlaying: false,
                  ),
                ),

                // Add a tiny bit of padding between data and bust shadow
                const SizedBox(height: 1),

                // Box containing the prowess data.
                SizedBox(
                  height: 57,
                  child: Stack(
                    children: [
                      // First column in the stack is the background row colors.
                      // We do this since we want to draw the rows even when
                      // there is no data.
                      Column(
                        children: <Widget>[
                          Container(
                              height: 19,
                              color: Colors.black.withOpacity(0.15)),
                          const SizedBox(height: 19),
                          Container(
                            height: 19,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.15),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                          )
                        ],
                      ),

                      // Now we can map the actual data (N.B. this design
                      // assumes we have less than 3 skills per character).
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: character.prowess.keys.map((skill) {
                          return Container(
                            height: 19,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(children: [
                                SkillIcon(skill,
                                    width: 11, height: 10, opacity: 0.7),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ProwessProgress(
                                    innerPadding: const EdgeInsets.all(1.0),
                                    background: Colors.black.withOpacity(0.28),
                                    color: skillColor[skill],
                                    borderRadius: BorderRadius.circular(3.5),
                                    progress: character.prowessProgress(skill),
                                  ),
                                )
                              ]),
                            ),
                          );
                        }).toList(),
                      ),
                      Transform(
                        transform: Matrix4.translationValues(0, 20, 0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              width: 16,
                              height: 15,
                              child: FlareActor("assets/flare/SelectArrow.flr",
                                  alignment: Alignment.topCenter,
                                  shouldClip: false,
                                  fit: BoxFit.contain,
                                  animation: isSelected ? "on" : "off")),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
