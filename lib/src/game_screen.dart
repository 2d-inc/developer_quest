import 'package:dev_rpg/src/game_screen/character_pool_page.dart';
import 'package:dev_rpg/src/game_screen/stats_page.dart';
import 'package:dev_rpg/src/game_screen/task_pool_page.dart';
import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/shared_state/game/character_pool.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/app_bar/coin_badge.dart';
import 'package:dev_rpg/src/widgets/app_bar/joy_badge.dart';
import 'package:dev_rpg/src/widgets/app_bar/stat_separator.dart';
import 'package:dev_rpg/src/widgets/app_bar/users_badge.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  @override
  GameScreenState createState() {
    return GameScreenState();
  }
}

class GameScreenState extends State<GameScreen> {
  int _index = 0;

  final _controller = PageController();

  GameScreenState() {
    _controller.addListener(() {
      if (_controller.page.round() != _index) {
        setState(() {
          _index = _controller.page.round();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(59, 59, 73, 1.0),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Consumer<Company>(
          builder: (context, company) {
            // Using RepaintBoundary here because this part of the UI changes
            // frequently.
            return RepaintBoundary(
              child: Row(
                children: [
                  Expanded(child: UsersBadge(company.users)),
                  StatSeparator(),
                  Expanded(child: JoyBadge(company.joy)),
                  StatSeparator(),
                  Expanded(child: CoinBadge(company.coin)),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: contentColor,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _index,
        onTap: (index) => setState(() {
              _index = index;
              _controller.jumpToPage(index);
            }),
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Consumer<CharacterPool>(
              builder: (context, characterPool) => Stack(
                    overflow: Overflow.visible,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          width: 25,
                          height: 29,
                          child: FlareActor("assets/flare/TeamIcon.flr",
                              alignment: Alignment.bottomCenter,
                              shouldClip: false,
                              fit: BoxFit.contain,
                              animation: _index == 0 ? "active" : "inactive"),
                        ),
                      ),
                      Positioned(
                        top: -20.0,
                        right: -15.0,
                        child: characterPool.isUpgradeAvailable
                            ? const SizedBox(
                                width: 31,
                                height: 31,
                                child: FlareActor(
                                    "assets/flare/NotificationIcon.flr",
                                    alignment: Alignment.bottomCenter,
                                    shouldClip: false,
                                    fit: BoxFit.contain,
                                    animation: "appear"),
                              )
                            : Container(),
                      )
                    ],
                  ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                'Team',
                style: buttonTextStyle.apply(
                  fontSizeDelta: -2,
                  color: _index == 0
                      ? Colors.white
                      : Colors.white.withOpacity(0.35),
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SizedBox(
                width: 24,
                height: 25,
                child: FlareActor("assets/flare/TasksIcon.flr",
                    alignment: Alignment.bottomCenter,
                    shouldClip: false,
                    fit: BoxFit.contain,
                    animation: _index == 1 ? "active" : "inactive"),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                'Tasks',
                style: buttonTextStyle.apply(
                  fontSizeDelta: -2,
                  color: _index == 1
                      ? Colors.white
                      : Colors.white.withOpacity(0.35),
                ),
              ),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _controller,
        children: [
          CharacterPoolPage(),
          TaskPoolPage(),
          StatsPage(),
        ],
      ),
    );
  }
}
