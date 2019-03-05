import 'package:dev_rpg/src/game_screen/npc_pool_page.dart';
import 'package:dev_rpg/src/game_screen/stat_badge.dart';
import 'package:dev_rpg/src/game_screen/stats_page.dart';
import 'package:dev_rpg/src/game_screen/task_pool_page.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:dev_rpg/src/shared_state/user.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  @override
  GameScreenState createState() {
    return new GameScreenState();
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
      appBar: AppBar(
          title: Provide<User>(
              builder: (context, child, user) => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        StatBadge("XP", user.xp),
                        StatBadge("C", user.coin)
                      ]))),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) => setState(() {
              _index = index;
              _controller.jumpToPage(index);
            }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Team'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            title: Text('Tasks'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            title: Text('Stats'),
          ),
        ],
      ),
      body: PageView(
        controller: _controller,
        children: [
          NpcPoolPage(),
          TaskPoolPage(),
          StatsPage(),
        ],
      ),
    );
  }
}
