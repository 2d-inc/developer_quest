import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/widgets/app_bar/stat_badge.dart';

/// Visually indicates the number of users the [Company] has amassed for this
/// game session.
class UsersBadge extends StatBadge<double> {
  UsersBadge(StatValue<double> listenable)
      : super("Users", listenable, flare: "assets/flare/Users.flr");

  /// Play a celebration/call to attention animation after the value changes by 100 users.
  @override
  double get celebrateAfter => 100.0;
}
