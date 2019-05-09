import 'package:dev_rpg/src/game_screen/character_style.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/character_pool.dart';
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

import '../rpg_layout_builder.dart';

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
    var isUnassigning = (widget.workItem.assignedTeam?.isNotEmpty ?? false) &&
        _selected.isEmpty;
    var isButtonDisabled = !isUnassigning && _selected.isEmpty;

    return RpgLayoutBuilder(
      builder: (context, layout) => Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: modalMaxWidth,

                  // If we're showing the wide layout, make sure this modal
                  // isn't too tall by using a factor of the same width
                  // constraint as a constraint for the height.
                  maxHeight: layout == RpgLayout.slim
                      ? double.infinity
                      : modalMaxWidth * 1.1),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Container(
                  color: modalBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: horizontalPadding,
                        child: Text(widget.workItem.name,
                            style: contentLargeStyle),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: horizontalPadding,
                        child: Text('SKILLS REQUIRED:',
                            style: buttonTextStyle.apply(
                                fontSizeDelta: -4,
                                color: secondaryContentColor)),
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
                          builder: (context, characterPool, child) {
                            var characters = characterPool.fullTeam;
                            return characters.isEmpty
                                ? const Center(
                                    child: Text(
                                      'Hire some teammates to complete '
                                      'this task!',
                                      style: contentLargeStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: horizontalPadding,
                                    itemCount: characters.length,
                                    itemBuilder: (context, index) {
                                      var character = characters[index];
                                      return TeamPickerItem(
                                        character,
                                        isSelected:
                                            _selected.contains(character),
                                        toggleSelection:
                                            _toggleCharacterSelected,
                                        // Show the character as not selectable
                                        // if they are currently assigned to
                                        // another task
                                        isDisabled: character.isBusy &&
                                            !(widget.workItem.assignedTeam
                                                    ?.contains(character) ??
                                                false),
                                      );
                                    });
                          },
                        ),
                      ),
                      Padding(
                        padding: horizontalPadding.add(
                          EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).padding.bottom + 15),
                        ),
                        child: WideButton(
                          buttonKey: const Key('team_pick_ok'),
                          onPressed: () => Navigator.pop(context, _selected),
                          paddingTweak: const EdgeInsets.only(right: -7),
                          background: isButtonDisabled
                              ? contentColor.withOpacity(0.1)
                              : const Color.fromRGBO(84, 114, 239, 1),
                          child: Text(
                            isUnassigning ? 'UNASSIGN TEAM' : 'ASSIGN TEAM',
                            style: buttonTextStyle.apply(
                              color: isButtonDisabled
                                  ? contentColor.withOpacity(0.25)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
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

/// Detail card for the available character in the team assignment list.
/// This presents the user with the stats of the character and the ability
/// to select the character by tapping on this whole widget.
class TeamPickerItem extends StatelessWidget {
  final Character character;
  final bool isSelected;
  final bool isDisabled;
  final void Function(Character character, bool selected) toggleSelection;

  static const Duration animationDuration = Duration(milliseconds: 175);
  const TeamPickerItem(this.character,
      {this.isSelected = false, this.toggleSelection, this.isDisabled});

  @override
  Widget build(BuildContext context) {
    var characterStyle = CharacterStyle.from(character);

    assert(
        character.prowess.keys.length <= 3,
        'UI is prepared for max 3 skills, yet '
        'character has ${character.prowess}');

    var backgroundColor = isDisabled
        ? disabledColor
        : isSelected
            ? const Color.fromRGBO(84, 114, 239, 1)
            : const Color.fromRGBO(69, 69, 82, 1);
    return AnimatedPadding(
      padding: isSelected
          ? const EdgeInsets.only(top: 27, bottom: 50)
          : const EdgeInsets.only(top: 47, bottom: 30),
      duration: animationDuration,
      curve: Curves.easeInOut,
      child: InkWell(
        key: Key(character.id),
        onTap: () =>
            isDisabled ? null : toggleSelection(character, !isSelected),
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: AnimatedContainer(
            duration: animationDuration,
            width: 130,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: isSelected && !isDisabled
                        ? const Color.fromRGBO(26, 50, 155, 0.3)
                        : Colors.black.withOpacity(0.17),
                    offset: const Offset(0, 10),
                    blurRadius: isSelected ? 30 : 10),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: backgroundColor,
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: HiringBust(
                    filename: characterStyle.flare,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                    hiringState: isDisabled
                        ? HiringBustState.locked
                        : HiringBustState.hired,
                    isPlaying: false,
                  ),
                ),

                // Add a tiny bit of padding between data and bust shadow.
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
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                          )
                        ],
                      ),

                      // Now we can map the actual data (N.B. this design
                      // requires less than 3 skills per character).
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: character.prowess.keys.map((skill) {
                          return Container(
                            height: 19,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  SkillIcon(skill,
                                      width: 11, height: 10, opacity: 0.7),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ProwessProgress(
                                      innerPadding: const EdgeInsets.all(1),
                                      background:
                                          Colors.black.withOpacity(0.28),
                                      color: skillColor[skill],
                                      borderRadius: BorderRadius.circular(3.5),
                                      progress:
                                          character.getProwessProgress(skill),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Transform(
                        transform: Matrix4.translationValues(0, 20, 0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: _SelectArrow(isSelected),
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

/// An animated arrow that shows up below the character to indicate whether
/// they've been assigned to the team or not.
class _SelectArrow extends StatefulWidget {
  final bool isSelected;

  const _SelectArrow(this.isSelected);

  @override
  _SelectArrowState createState() => _SelectArrowState();
}

class _SelectArrowState extends State<_SelectArrow> {
  String _animation;
  bool _snapToEnd;
  @override
  void initState() {
    _animation = 'off';
    _snapToEnd = true;
    super.initState();
  }

  @override
  void didUpdateWidget(_SelectArrow oldWidget) {
    String animation = widget.isSelected ? 'on' : 'off';
    if (animation != _animation) {
      setState(() {
        _animation = animation;
        _snapToEnd = false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 15,
      child: FlareActor('assets/flare/SelectArrow.flr',
          alignment: Alignment.topCenter,
          shouldClip: false,
          snapToEnd: _snapToEnd,
          fit: BoxFit.contain,
          animation: _animation),
    );
  }
}
