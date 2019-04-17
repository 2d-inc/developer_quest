import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/widgets/app_bar/stat_badge.dart';

/// Visually indicates the amount of capital the [Company] has amassed for this
/// game session.
class CoinBadge extends StatBadge<int> {
  CoinBadge(StatValue<int> listenable)
      : super("Capital", listenable, flare: "assets/flare/Coin.flr");

  /// Play the indicator animation after this value changes by at least 5 coins.
  @override
  int get celebrateAfter => 5;
}
