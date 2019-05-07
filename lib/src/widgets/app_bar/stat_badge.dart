import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Displays a game statistic with its name and value. Also displays
/// an animated icon. Meant to be implemented by specific stats,
/// which are expected to either provide their own animation playback
/// logic, or provide the celebrateAfter amount to automatically play
/// the 'points' animation after the state has changed by this amount.
abstract class StatBadge<T extends num> extends StatefulWidget {
  final String stat;
  final double scale;
  final bool isWide;

  @required
  final String flare;

  @required
  final StatValue<T> listenable;

  const StatBadge(this.stat, this.listenable,
      {this.flare, this.scale = 1, this.isWide});

  /// This is intentionally abstract to allow deriving stats to specify
  /// when they should celebrate. N.B. that a value of 0 means to always
  /// play the 'points' animation.
  T get celebrateAfter;

  @override
  StatBadgeState<T> createState() => StatBadgeState<T>();
}

/// The [StatBadge] state will automatically play the Flare 'points' animation
/// when the stat value [StatBage.celebrateAfter] value has changed by a certain
/// amount since the last time it has played the animation.
class StatBadgeState<T extends num> extends State<StatBadge<T>> {
  final FlareControls controls = FlareControls();
  T _lastStatValue;

  @override
  void initState() {
    _lastStatValue = widget.listenable.number;
    super.initState();
  }

  void valueChanged() {
    T change = widget.listenable.number - _lastStatValue;
    if (widget.celebrateAfter == 0 || change > widget.celebrateAfter) {
      controls.play('points');
      _lastStatValue = widget.listenable.number;
    } else if (change < 0) {
      // Make sure to decrement the last points value so we can celebrate
      // when we go to this value + our threshold.
      _lastStatValue = widget.listenable.number;
    }
  }

  @override
  void didUpdateWidget(StatBadge<T> oldWidget) {
    oldWidget?.listenable?.removeListener(valueChanged);
    widget?.listenable?.addListener(valueChanged);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 15),
        Container(
          width: 26 * widget.scale,
          height: 26 * widget.scale,
          child: FlareActor(
            widget.flare,
            alignment: Alignment.topCenter,
            shouldClip: false,
            fit: BoxFit.contain,
            animation: 'appear',
            controller: controls,
          ),
        ),
        SizedBox(width: widget.scale * 9),
        Expanded(
            child: widget.isWide
                ? _WideStatData(
                    listenable: widget.listenable,
                    scale: widget.scale,
                    stat: widget.stat,
                  )
                : _SlimStatData(
                    listenable: widget.listenable,
                    scale: widget.scale,
                    stat: widget.stat,
                  ))
      ],
    );
  }
}

class _SlimStatData extends StatelessWidget {
  final ValueListenable<String> listenable;
  final double scale;
  final String stat;
  const _SlimStatData({this.listenable, this.scale, this.stat});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder(
          valueListenable: listenable,
          builder: (context, String value, child) => Text(value,
              style: buttonTextStyle.apply(
                  color: Colors.white,
                  fontSizeDelta: -2,
                  fontSizeFactor: scale)),
        ),
        Text(
          stat.toUpperCase(),
          style: buttonTextStyle.apply(
              color: Colors.white.withOpacity(0.5),
              fontSizeDelta: -4,
              fontSizeFactor: scale),
        ),
      ],
    );
  }
}

class _WideStatData extends StatelessWidget {
  final ValueListenable<String> listenable;
  final double scale;
  final String stat;
  const _WideStatData({this.listenable, this.scale, this.stat});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          stat.toUpperCase(),
          style: buttonTextStyle.apply(
              color: Colors.white.withOpacity(0.5),
              fontSizeDelta: -4,
              fontSizeFactor: scale),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: listenable,
            builder: (context, String value, child) => Text(value,
                style: buttonTextStyle.apply(
                    color: Colors.white,
                    fontSizeDelta: -1,
                    fontSizeFactor: scale)),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }
}
