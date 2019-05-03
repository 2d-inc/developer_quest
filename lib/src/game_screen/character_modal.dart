import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/keyboard.dart';
import 'package:dev_rpg/src/widgets/modal/character_modal_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flare_flutter/flare_controls.dart';

/// Displays the stats of an [Character] and offers the option to upgrade them.
class CharacterModal extends StatefulWidget {
  @override
  _CharacterModalState createState() => _CharacterModalState();
}

class _CharacterModalState extends State<CharacterModal> {
  FlareControls _controls;
  FocusNode _focusNode;
  @override
  void initState() {
    _controls = FlareControls();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CharacterBoxConstraints(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [CharacterImage(_controls), CharacterStats(_controls)]),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
