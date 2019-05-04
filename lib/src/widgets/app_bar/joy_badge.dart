import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/widgets/app_bar/stat_badge.dart';

/// Visually indicates the level of joy via a Flare animation with distinct
/// sad, happy, neutral states and a call to attention animation whenever
/// the numeric value changes.
class JoyBadge extends StatBadge<double> {
  JoyBadge(StatValue<double> listenable,
      {double scale = 1, bool isWide = false})
      : super('Joy', listenable,
            flare: 'assets/flare/Joy.flr', scale: scale, isWide: isWide);

  /// Play the celebration animation whenever there's a change
  /// 0 is a flag for always in this case
  @override
  double get celebrateAfter => 0;

  @override
  JoyBadgeState createState() => JoyBadgeState();
}

/// The three emotions this widget can display
enum _Emotion { sad, happy, neutral }

class JoyBadgeState extends StatBadgeState<double> {
  _Emotion _emotion;

  _Emotion get emotion => _emotion;
  set emotion(_Emotion value) {
    if (value == _emotion) {
      return;
    }
    _emotion = value;
    switch (_emotion) {
      case _Emotion.sad:
        controls.play('sad');
        break;
      case _Emotion.happy:
        controls.play('happy');
        break;
      case _Emotion.neutral:
        controls.play('neutral');
        break;
    }
  }

  @override
  void valueChanged() {
    double joy = widget.listenable.number;
    if (joy < 0) {
      emotion = _Emotion.sad;
    } else if (joy > 3) {
      emotion = _Emotion.happy;
    } else {
      emotion = _Emotion.neutral;
    }
    super.valueChanged();
  }
}
