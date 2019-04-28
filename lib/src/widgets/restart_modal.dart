import 'dart:async';

import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:flutter/material.dart';

import '../rpg_layout_builder.dart';
import '../style.dart';
import 'buttons/wide_button.dart';

/// A dialog displayed when a certain period of inactivity has
/// elapsed. This gives the user the option to confirm they are
/// still around, otherwise the game will reset.
class RestartModal extends StatefulWidget {
  final World world;
  const RestartModal(this.world);
  @override
  _RestartModalState createState() => _RestartModalState();
}

class _RestartModalState extends State<RestartModal> {
  int _secondsRemaining;
  Timer _countdown;
  @override
  void initState() {
    _secondsRemaining = 5;
    _scheduleCountdown();
    super.initState();
  }

  void _scheduleCountdown() {
    _countdown?.cancel();
    _countdown = Timer(
      Duration(seconds: 1),
      () {
        setState(() {
          _secondsRemaining--;

          if (_secondsRemaining == 0) {
            _backToMainMenu();
            return;
          }
        });
        _scheduleCountdown();
      },
    );
  }

  void _backToMainMenu() {
    widget.world.reset();
    Navigator.popUntil(context, (route) {
      return route.settings.name == '/';
    });
  }

  void _stillHere(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _countdown?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RpgLayoutBuilder(
      builder: (context, layout) => Align(
            alignment: layout == RpgLayout.slim
                ? Alignment.center
                : Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Material(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: modalMaxWidth),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    constraints:
                        const BoxConstraints(minWidth: double.infinity),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 100),
                            blurRadius: 100),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 17),
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromRGBO(151, 151, 151, 1),
                              width: 4,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(44),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _secondsRemaining.toString(),
                              style: contentLargeStyle.apply(fontSizeDelta: 24),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        const Text('Are you still there?',
                            style: contentLargeStyle),
                        const SizedBox(height: 21),
                        Text('Game will restart in $_secondsRemaining seconds.',
                            style: contentStyle),
                        const SizedBox(height: 21),
                        WideButton(
                          onPressed: () => _stillHere(context),
                          paddingTweak: const EdgeInsets.only(right: -7),
                          background: const Color.fromRGBO(84, 114, 239, 1),
                          shadowColor: const Color.fromRGBO(84, 114, 244, 0.25),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'I\'M STILL HERE!',
                              style: buttonTextStyle.apply(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
