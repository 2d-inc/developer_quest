import 'package:dev_rpg/src/game_screen/character_pool_page.dart';
import 'package:dev_rpg/src/game_screen/task_pool_page.dart';
import 'package:dev_rpg/src/shared_state/game/character_pool.dart';
import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/app_bar/coin_badge.dart';
import 'package:dev_rpg/src/widgets/app_bar/joy_badge.dart';
import 'package:dev_rpg/src/widgets/app_bar/stat_separator.dart';
import 'package:dev_rpg/src/widgets/app_bar/users_badge.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreenSlim extends StatefulWidget {
  @override
  GameScreenSlimState createState() {
    return GameScreenSlimState();
  }
}

class GameScreenSlimState extends State<GameScreenSlim> {
  int _index = 0;

  final _controller = PageController();

  GameScreenSlimState() {
    _controller.addListener(() {
      if (_controller.page.round() != _index) {
        setState(() {
          _index = _controller.page.round();
        });
      }
    });
  }

  void _showPageIndex(int index) {
    setState(() {
      _index = index;
    });
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(59, 59, 73, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Consumer<Company>(
          builder: (context, company, child) {
            // Using RepaintBoundary here because this part of the UI
            // changes frequently.
            return RepaintBoundary(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: const BorderSide(
                      color: statsSeparatorColor,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(child: UsersBadge(company.users)),
                    StatSeparator(),
                    Expanded(child: JoyBadge(company.joy)),
                    StatSeparator(),
                    Expanded(child: CoinBadge(company.coin)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Consumer<CharacterPool>(
            builder: (context, characterPool, child) => _BottomNavigationButton(
                  'assets/flare/TeamIcon.flr',
                  label: 'Team',
                  tap: () => _showPageIndex(0),
                  isSelected: _index == 0,
                  hasNotification: characterPool.isUpgradeAvailable,
                  iconSize: const Size(25, 29),
                  padding: const EdgeInsets.only(top: 10),
                ),
          ),
          _BottomNavigationButton(
            'assets/flare/TasksIcon.flr',
            label: 'Tasks',
            tap: () => _showPageIndex(1),
            isSelected: _index == 1,
            iconSize: const Size(24, 25),
            padding: const EdgeInsets.only(top: 15),
          ),
        ],
      ),
      body: PageView(
        controller: _controller,
        children: const [CharacterPoolPage(), TaskPoolPage()],
      ),
    );
  }
}

/// A custom bottom navigation button with the ability to paint a
/// custom background color, play a selection animation, and show
/// a notification icon.
class _BottomNavigationButton extends StatefulWidget {
  final bool hasNotification;
  final String flare;
  final Size iconSize;
  final bool isSelected;
  final EdgeInsets padding;
  final VoidCallback tap;
  final String label;

  const _BottomNavigationButton(this.flare,
      {this.isSelected = false,
      this.hasNotification = false,
      this.padding = const EdgeInsets.only(top: 15),
      this.iconSize = const Size(25, 29),
      this.tap,
      this.label});

  @override
  __BottomNavigationButtonState createState() =>
      __BottomNavigationButtonState();
}

class __BottomNavigationButtonState extends State<_BottomNavigationButton> {
  /// We use this variable as a way to determine if this is the first time the
  /// button is being shown.
  /// If that's the case, we simply pop to the last frame of the animation
  /// instead of playing it through.
  /// This prevents all of the bottom navigation buttons from playing an
  /// 'intro' animation when the screen is first displayed.
  bool _isFirstShow = true;

  @override
  void didUpdateWidget(_BottomNavigationButton oldWidget) {
    setState(() {
      _isFirstShow = false;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        type: MaterialType.canvas,
        color: widget.isSelected
            ? const Color.fromRGBO(48, 48, 59, 1)
            : contentColor,
        child: InkWell(
          onTap: widget.tap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                overflow: Overflow.visible,
                children: [
                  Padding(
                    padding: widget.padding,
                    child: SizedBox(
                      width: widget.iconSize.width,
                      height: widget.iconSize.height,
                      child: FlareActor(widget.flare,
                          alignment: Alignment.center,
                          shouldClip: false,
                          fit: BoxFit.contain,
                          snapToEnd: _isFirstShow,
                          animation: widget.isSelected ? 'active' : 'inactive'),
                    ),
                  ),
                  Positioned(
                    top: -20,
                    right: -15,
                    child: widget.hasNotification
                        ? const SizedBox(
                            width: 31,
                            height: 31,
                            child: FlareActor(
                                'assets/flare/NotificationIcon.flr',
                                alignment: Alignment.center,
                                shouldClip: false,
                                fit: BoxFit.contain,
                                animation: 'appear'),
                          )
                        : Container(),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 5, bottom: MediaQuery.of(context).padding.bottom + 10),
                child: Text(
                  widget.label,
                  style: buttonTextStyle.apply(
                    fontSizeDelta: -2,
                    color: widget.isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.35),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
