import 'dart:async';

import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/prowess_progress.dart';
import 'package:flutter/material.dart';

/// Progress bar with tap button to boost progress for work items.
class WorkListProgress extends StatefulWidget {
  final Color progressColor;
  final WorkItem workItem;

  const WorkListProgress({this.workItem, this.progressColor});

  @override
  _WorkListProgressState createState() => _WorkListProgressState();
}

class _WorkListProgressState extends State<WorkListProgress> {
  bool _showBoost = false;
  Timer _hideBoostTimer;
  void _hideBoost() {
    setState(() => _showBoost = false);
  }

  @override
  void dispose() {
    super.dispose();
    _hideBoostTimer?.cancel();
  }

  void _boostProgress(WorkItem item) {
    _hideBoostTimer?.cancel();
    _hideBoostTimer = Timer(const Duration(milliseconds: 400), _hideBoost);

    if (item.addBoost()) {
      setState(() => _showBoost = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var workItem = widget.workItem;

    return Row(
      children: <Widget>[
        TapButton(
          color: widget.progressColor,
          onPressed: () => _boostProgress(workItem),
          isDisabled: workItem.isComplete,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedOverflowBox(
                alignment: Alignment.bottomRight,
                size: const Size.fromHeight(0),
                child: AnimatedOpacity(
                  opacity: _showBoost || workItem.isComplete ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: workItem.isComplete
                        ? Text('LAUNCH!',
                            style: buttonTextStyle.apply(color: attentionColor))
                        : Text('+10',
                            style: buttonTextStyle.apply(
                                color: widget.progressColor, fontSizeDelta: 8)),
                  ),
                ),
              ),
              ProwessProgress(
                  height: 8,
                  borderRadius: BorderRadius.circular(4),
                  color: widget.progressColor,
                  background: const Color.fromRGBO(69, 69, 82, 1),
                  progress: workItem.percentComplete)
            ],
          ),
        ),
      ],
    );
  }
}

/// A visual indicator that a region can be tapped on.
class TapButton extends StatefulWidget {
  final bool isDisabled;
  final Color color;
  final VoidCallback onPressed;
  const TapButton({this.color, this.isDisabled, this.onPressed});

  @override
  _TapButtonState createState() => _TapButtonState();
}

class _TapButtonState extends State<TapButton> {
  bool _isPressed = false;
  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _onTap() {
    if (widget.onPressed != null) {
      widget.onPressed();
    }
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isDisabled ? null : _onTapDown,
      onTapUp: widget.isDisabled ? null : _onTapUp,
      onTap: widget.isDisabled ? null : _onTap,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: SizedOverflowBox(
        size: const Size.square(52),
        child: Transform(
          transform: Matrix4.translationValues(-5, 0, 0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: _isPressed ? 78 : 0,
                    height: _isPressed ? 78 : 0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color.withOpacity(0.32))),
              ),
              Center(
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isDisabled
                        ? disabledTaskColor.withOpacity(0.1)
                        : widget.color,
                    boxShadow: widget.isDisabled
                        ? null
                        : [
                            BoxShadow(
                                color: widget.color.withOpacity(0.25),
                                offset: const Offset(0, 10),
                                blurRadius: 10,
                                spreadRadius: 0),
                          ],
                  ),
                ),
              ),
              Center(
                  child: Text('TAP',
                      style: buttonTextStyle.apply(
                          fontSizeDelta: -4,
                          color: widget.isDisabled
                              ? disabledTaskColor
                              : Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}
