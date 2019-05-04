library chompy;

import 'dart:math';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'code_chomper_screen.dart';

const Color chompBlue = Color(0xFF4CB3FF);
const Color chompRed = Color(0xFFFC4B67);
const Color _chompBackground = Color.fromRGBO(38, 36, 87, 1);
const TextStyle chompTextStyle =
    TextStyle(fontFamily: 'SpaceMonoRegular', fontSize: 12, color: chompBlue);
const double _keyDefaultWidth = 32;
const double _keyPadding = 5;
const double _maxWidth = 1000;

/// The main screen for the code chomper mini game.
class CodeChomper extends StatefulWidget {
  static const String miniGameRouteName = '/chompy';
  final String codeFilename;
  const CodeChomper(this.codeFilename);

  @override
  _CodeChomperState createState() => _CodeChomperState();
}

class _CodeChomperState extends State<CodeChomper> {
  CodeChomperController _chomperController;
  bool _isGameOver = false;
  @override
  void initState() {
    super.initState();
    _chomperController = CodeChomperController(widget.codeFilename);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    var devicePadding = media.padding;
    return Material(
      color: const Color.fromRGBO(38, 36, 87, 1),
      child: Padding(
        padding: EdgeInsets.only(
          top: devicePadding.top + 11,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'CODE CHOMPER: ',
                            style: chompTextStyle,
                          ),
                          Text(
                            'ACTIVE',
                            style: chompTextStyle.apply(
                              fontFamily: 'SpaceMonoBold',
                              color: const Color.fromRGBO(206, 83, 83, 1),
                            ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            width: 120,
                            height: 10,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              color: chompBlue.withOpacity(0.24),
                            ),
                            child: Row(
                              children: [
                                for (int i = 0; i < 5; i++)
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 3),
                                    height: 3,
                                    width: 18,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(1.5),
                                      ),
                                      color: chompBlue,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(height: 1, color: chompBlue),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          for (int i = 0; i < 3; i++)
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: i == 2 ? 0 : 5),
                                height: 1,
                                color: chompBlue.withOpacity(0.5),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Column(
                          children: [
                            // Game renderer goes here
                            Expanded(
                              child: CodeChomperScreen(_chomperController),
                            ),

                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapDown: (details) {
                                if (_chomperController
                                    .addCode(details.globalPosition)) {
                                  setState(() {
                                    _isGameOver = true;
                                  });
                                }
                              },
                              child: _ChompyKeyboard(),
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: _GameOverScreen(isGameOver: _isGameOver),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The game over screen which fades in once the last line in the game
/// has been typed.
class _GameOverScreen extends StatelessWidget {
  final bool isGameOver;
  const _GameOverScreen({
    this.isGameOver = false,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isGameOver,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: isGameOver ? _chompBackground : _chompBackground.withOpacity(0),
        child: isGameOver
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 160,
                    height: 160,
                    child: FlareActor('assets/flare/Chomper.flr',
                        alignment: Alignment.center,
                        shouldClip: false,
                        fit: BoxFit.contain,
                        animation: 'Game Over'),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'YOU WIN!',
                    style: chompTextStyle.apply(fontSizeDelta: 26),
                  ),
                  const SizedBox(height: 30),
                  FlatButton(
                    onPressed: () => Navigator.pop(context, null),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    color: const Color.fromRGBO(27, 26, 68, 1),
                    shape: Border.all(width: 1, color: chompBlue),
                    child: Text(
                      'CONTINUE',
                      style: chompTextStyle.apply(fontSizeDelta: 8),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              )
            : Container(),
      ),
    );
  }
}

/// The keyboard with the TAP TO CODE text at the bottom of the game.
class _ChompyKeyboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    var devicePadding = media.padding;
    var width = min(_maxWidth, media.size.width);
    var defaultKeysPerRow = (width / (_keyDefaultWidth + _keyPadding)).floor();

    return Container(
      color: Colors.black.withOpacity(0.33),
      child: Column(
        children: [
          const SizedBox(height: 5),
          _TapDecorationLine(),
          const SizedBox(height: 5),
          Text('TAP TO CODE', style: chompTextStyle.apply(fontSizeDelta: 8)),
          const SizedBox(height: 5),
          _TapDecorationLine(),
          const SizedBox(height: 10),
          _KeyboardRow(
            defaultKeysPerRow,
          ),
          _KeyboardRow(
            defaultKeysPerRow - 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _ChompyKey(_keyDefaultWidth * 1.25),
              const SizedBox(width: 5),
              _KeyboardRow(
                defaultKeysPerRow - 3,
              ),
              const SizedBox(width: 5),
              const _ChompyKey(_keyDefaultWidth * 1.25),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ChompyKey(width / 5),
              const SizedBox(width: 2),
              _ChompyKey(width / 2),
              const SizedBox(width: 2),
              _ChompyKey(width / 5),
            ],
          ),
          SizedBox(height: devicePadding.bottom),
        ],
      ),
    );
  }
}

/// A row of keys in the keyboard.
class _KeyboardRow extends StatelessWidget {
  final int numKeys;
  const _KeyboardRow(this.numKeys);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < numKeys; i++) const _ChompyKey(_keyDefaultWidth)
      ],
    );
  }
}

/// A multi line detail/complication for the UI that is used repeated on the screen.
class _TapDecorationLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 2),
        Container(
          height: 1,
          width: 5,
          color: chompBlue,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            height: 1,
            color: chompBlue,
          ),
        ),
        Container(
          height: 1,
          width: 5,
          color: chompBlue,
        ),
        const SizedBox(width: 2),
      ],
    );
  }
}

/// A single tappable key for the chomper keyboard.
class _ChompyKey extends StatefulWidget {
  final double width;
  const _ChompyKey(this.width);

  @override
  _ChompyKeyState createState() => _ChompyKeyState();
}

class _ChompyKeyState extends State<_ChompyKey>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorTween;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 122),
    );

    _colorTween = ColorTween(begin: chompBlue.withOpacity(0), end: Colors.white)
        .animate(_animationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) {
        _colorTween =
            ColorTween(begin: chompBlue.withOpacity(0), end: Colors.white)
                .animate(_animationController);
        _animationController.reset();
        _animationController.forward().whenComplete(() {
          _animationController.reverse(from: 0.5);
        });
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Container(
              margin: const EdgeInsets.all(_keyPadding / 2),
              height: 42,
              width: widget.width,
              decoration: BoxDecoration(
                color: _colorTween.value,
                border: Border.all(
                  color: chompBlue.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
      ),
    );
  }
}
