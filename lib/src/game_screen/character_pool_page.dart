import 'package:dev_rpg/src/game_screen/character_modal.dart';
import 'package:dev_rpg/src/game_screen/character_style.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/character_pool.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/character_pool/character.dart';
import 'package:flutter/gestures.dart';
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
  void _startPlaying(PointerEnterEvent _) => null;
  void _stopPlaying(PointerExitEvent _) => null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Stack(
        children: <Widget>[
          const CharacterBox(),
          CharacterDisplay(),
        ],
      ),
    );
  }
}