import 'package:dev_rpg/src/game_screen/npc_pool_page.dart';
import 'package:dev_rpg/src/game_screen/stat_badge.dart';
import 'package:dev_rpg/src/game_screen/stats_page.dart';
import 'package:dev_rpg/src/game_screen/task_pool_page.dart';
import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
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
          title: Provide<Company>(
              builder: (context, child, company) => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        StatBadge("Users", company.users),
                        StatBadge("Joy", company.joy),
                        StatBadge("C", company.coin)
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
