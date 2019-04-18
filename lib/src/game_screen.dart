import 'package:dev_rpg/src/game_screen/character_pool_page.dart';
import 'package:dev_rpg/src/game_screen/stats_page.dart';
import 'package:dev_rpg/src/game_screen/task_pool_page.dart';
import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/shared_state/game/character_pool.dart';
import 'package:dev_rpg/src/widgets/app_bar/coin_badge.dart';
import 'package:dev_rpg/src/widgets/app_bar/joy_badge.dart';
import 'package:dev_rpg/src/widgets/app_bar/stat_separator.dart';
import 'package:dev_rpg/src/widgets/app_bar/users_badge.dart';
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
        currentIndex: _index,
        onTap: (index) => setState(() {
              _index = index;
              _controller.jumpToPage(index);
            }),
        items: [
          BottomNavigationBarItem(
            icon: Consumer<CharacterPool>(
                builder: (context, characterPool) =>
                    characterPool.isUpgradeAvailable
                        ? Stack(children: const [
                            Icon(Icons.person),
                            Positioned(
                              // draw a red marble
                              top: 0.0,
                              right: 0.0,
                              child: Icon(Icons.error,
                                  size: 14.0, color: Colors.redAccent),
                            )
                          ])
                        : const Icon(Icons.person)),
            title: const Text('Team'),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.work),
            title: Text('Tasks'),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            title: Text('Stats'),
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
