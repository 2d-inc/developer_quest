import 'package:dev_rpg/src/game_screen/character_modal.dart';
import 'package:dev_rpg/src/game_screen/character_style.dart';
import 'package:dev_rpg/src/rpg_layout_builder.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/character_pool.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/flare/hiring_bust.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a list of [Character]s that are available to the player.
class CharacterPoolPage extends StatelessWidget {
  final int numColumns;
  const CharacterPoolPage({this.numColumns = 2});

  @override
  Widget build(BuildContext context) {
    var characterPool = Provider.of<CharacterPool>(context);
    return Stack(
      children: [
        GridView.builder(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 128),
          itemCount: characterPool.children.length,
          gridDelegate: _gridStructure,
          itemBuilder: (context, index) =>
              ChangeNotifierProvider<Character>.value(
                notifier: characterPool.children[index],
                key: ValueKey(characterPool.children[index]),
                child: CharacterListItem(),
              ),
        ),
        _fadeOverlay,
      ],
    );
  }

  SliverGridDelegate get _gridStructure =>
      SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: numColumns,
          mainAxisSpacing: 0,
          crossAxisSpacing: 15,
          childAspectRatio: 0.65);

  Widget get _fadeOverlay {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1,
        child: IgnorePointer(
          child: Container(
            height: 128,
            decoration: const BoxDecoration(
              // Box decoration takes a gradient
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(59, 59, 73, 0),
                  Color.fromRGBO(59, 59, 73, 1)
                ],
                stops: [0, 1],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays the current state of an individual [Character]
/// Tapping on the [Character] opens up a modal window which
/// offers more details about stats and options to upgrade.
class CharacterListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Stack(
        children: [
          const CharacterBox(),
          CharacterDisplay(),
        ],
      ),
    );
  }
}

class CharacterDisplay extends StatelessWidget {
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
        key: ValueKey('hire-${character.id}'),
        customBorder: _inkWellBorder,
        onTap: () => _showModal(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: HiringBust(
                particleColor: attentionColor,
                filename: characterStyle.flare,
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
                hiringState: bustState,
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

  void _showModal(BuildContext context) {
    var character = Provider.of<Character>(context);
    showDialog<void>(
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
    return RpgLayoutBuilder(
      builder: (context, layout) {
        double textScale = layout == RpgLayout.ultrawide ? 1.25 : 1;
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
                    : bustState == HiringBustState.available
                        ? 'Hire!'
                        : 'Locked',
                style: contentStyle.apply(
                    fontSizeFactor: textScale,
                    color: bustState == HiringBustState.available
                        ? attentionColor
                        : Colors.white),
              )
            ],
          ),
        );
      },
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
