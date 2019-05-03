
import 'package:dev_rpg/src/game_screen/character_modal.dart';
import 'package:dev_rpg/src/game_screen/character_style.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/flare/hiring_bust.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterDisplay extends StatelessWidget {
  CharacterDisplay({
    bool isAnimating = false,
  }) : _isAnimating = isAnimating;

  final bool _isAnimating;

  @override
  Widget build(BuildContext context) {
    var character = Provider.of<Character>(context);
    var characterStyle = CharacterStyle.from(character);
    HiringBustState bustState = character.isHired
        ? HiringBustState.hired
        : character.canUpgradeOrHire
        ? HiringBustState.available
        : HiringBustState.locked;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        customBorder: _inkWellBorder,
        onTap: () => _showModal(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: HiringBust(
                particleColor: attentionColor,
                filename: characterStyle.flare,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                hiringState: bustState,
                isPlaying: _isAnimating,
              ),
            ),
            const SizedBox(height: 20),
            HiringInformation(bustState),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  RoundedRectangleBorder get _inkWellBorder =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

  Future<void> _showModal(BuildContext context) async {
    var character = Provider.of<Character>(context);
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ChangeNotifierProvider<Character>.value(
            notifier: character,
            child: CharacterModal(),
          );
        });
  }
}

class HiringInformation extends StatelessWidget {
  const HiringInformation(this.bustState);

  final HiringBustState bustState;

  @override
  Widget build(BuildContext context) {
    var character = Provider.of<Character>(context);
    return Opacity(
      opacity: character.isHired || character.canUpgradeOrHire ? 1 : 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          character.isHired
              ? Container()
              : Icon(
              bustState == HiringBustState.available
                  ? Icons.add_circle
                  : Icons.lock,
              color: !character.isHired && character.canUpgradeOrHire
                  ? attentionColor
                  : Colors.white),
          const SizedBox(width: 4),
          Text(
            bustState == HiringBustState.hired
                ? 'Hired'
                : bustState == HiringBustState.available ? 'Hire!' : 'Locked',
            style: contentStyle.apply(
                color: bustState == HiringBustState.available
                    ? attentionColor
                    : Colors.white),
          )
        ],
      ),
    );
  }
}

class CharacterBox extends StatelessWidget {
  const CharacterBox();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(69, 69, 82, 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}
