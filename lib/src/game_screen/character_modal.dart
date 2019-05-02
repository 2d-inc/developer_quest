import 'package:dev_rpg/src/game_screen/character_style.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/buttons/wide_button.dart';
import 'package:dev_rpg/src/widgets/flare/skill_icon.dart';
import 'package:dev_rpg/src/widgets/keyboard.dart';
import 'package:dev_rpg/src/widgets/prowess_progress.dart';
import 'package:dev_rpg/src/widgets/skill_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';

/// Displays the stats of an [Character] and offers the option to upgrade them.
class CharacterModal extends StatelessWidget {
  final FlareControls _controls = FlareControls();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (RawKeyEvent event) {
        if (event.runtimeType == RawKeyDownEvent &&
            (event.logicalKey.keyId == KeyCode.backspace ||
                event.logicalKey.keyId == KeyCode.escape)) {
          _focusNode.unfocus();
          Navigator.pop(context, null);
        }
      },
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: modalMaxWidth),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 280),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                CharacterImage(_controls),
                CharacterStats(_controls)
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class CharacterImage extends StatelessWidget {
  const CharacterImage(this._controls);

  final FlareControls _controls;

  @override
  Widget build(BuildContext context) {
    var characterStyle = CharacterStyle.from(Provider.of<Character>(context));
    return Flexible(
      fit: FlexFit.loose,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: modalMaxWidth * 0.75,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(25, 25, 30, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: FlareActor(characterStyle.flare,
                  alignment: Alignment.bottomCenter,
                  shouldClip: false,
                  fit: BoxFit.contain,
                  animation: 'idle',
                  controller: _controls),
            ),
            Align(
              alignment: Alignment.topRight,
              child: ButtonTheme(
                minWidth: 0,
                child: FlatButton(
                  padding: const EdgeInsets.all(0),
                  shape: null,
                  onPressed: () => Navigator.pop(context, null),
                  child: const Icon(
                    Icons.cancel,
                    color: Color.fromRGBO(250, 250, 255, .5),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CharacterStats extends StatelessWidget {
  const CharacterStats(this._controls);

  final FlareControls _controls;

  @override
  Widget build(BuildContext context) {
    var character = Provider.of<Character>(context);
    var characterStyle = CharacterStyle.from(character);
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Level ${character.level}',
                style: contentStyle.apply(color: secondaryContentColor),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7, bottom: 6),
                child: Text(
                  characterStyle.name,
                  style: contentLargeStyle,
                ),
              ),
              Text(
                characterStyle.description,
                style: contentSmallStyle,
              ),
              Column(
                children: character.prowess.keys
                    .map((Skill skill) => SkillDisplay(skill))
                    .toList(),
              ),
              const SizedBox(height: 40),
              UpgradeHireButton(_controls),
            ],
          ),
        ),
      ),
    );
  }
}

class UpgradeHireButton extends StatelessWidget {
  const UpgradeHireButton(this._controls);

  final FlareControls _controls;

  @override
  Widget build(BuildContext context) {
    var character = Provider.of<Character>(context);
    return WideButton(
      enabled: character.canUpgradeOrHire,
      onPressed: () {
        if (character.upgradeOrHire()) {
          _controls.play('success');
        }
      },
      paddingTweak: const EdgeInsets.only(right: -7),
      background: character.canUpgradeOrHire
          ? const Color.fromRGBO(84, 114, 239, 1)
          : contentColor.withOpacity(0.1),
      child: Row(
        children: [
          Text(
            character.isHired ? 'UPGRADE' : 'HIRE',
            style: buttonTextStyle.apply(
              color: character.canUpgradeOrHire
                  ? Colors.white
                  : contentColor.withOpacity(0.25),
            ),
          ),
          Expanded(child: Container()),
          const SizedBox(
            width: 20,
            height: 20,
            child: FlareActor(
              'assets/flare/Coin.flr',
              isPaused: true,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            character.upgradeCost.toString(),
            style: buttonTextStyle.apply(
              fontSizeDelta: -2,
              color: character.canUpgradeOrHire
                  ? const Color.fromRGBO(241, 241, 241, 1)
                  : contentColor.withOpacity(0.25),
            ),
          )
        ],
      ),
    );
  }
}

class SkillDisplay extends StatelessWidget {
  const SkillDisplay(this.skill);

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    var character = Provider.of<Character>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(children: <Widget>[
        Row(
          children: [
            Row(children: [
              SkillIcon(
                skill,
                color: const Color.fromRGBO(69, 69, 82, 1),
              ),
              const SizedBox(width: 10),
              Text(
                skillDisplayName[skill],
                style: contentStyle.apply(color: skillTextColor),
              )
            ]),
            Expanded(child: Container()),
            Text(
              character.prowess[skill].toString(),
              style: contentLargeStyle,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: ProwessProgress(
              color: skillColor[skill],
              borderRadius: BorderRadius.circular(3.5),
              progress: character.getProwessProgress(skill)),
        )
      ]),
    );
  }
}
