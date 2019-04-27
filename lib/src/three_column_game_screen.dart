import 'package:dev_rpg/src/game_screen/character_pool_page.dart';
import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/widgets/app_bar/coin_badge.dart';
import 'package:dev_rpg/src/widgets/app_bar/joy_badge.dart';
import 'package:dev_rpg/src/widgets/app_bar/stat_separator.dart';
import 'package:dev_rpg/src/widgets/app_bar/users_badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_screen/task_pool_page.dart';
import 'game_screen/three_col_task_pool_page.dart';

class ThreeColumnGameScreen extends StatefulWidget {
  @override
  _ThreeColumnGameScreenState createState() => _ThreeColumnGameScreenState();
}

class _ThreeColumnGameScreenState extends State<ThreeColumnGameScreen> {
  @override
  void initState() {
    Provider.of<World>(context, listen: false).start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(59, 59, 73, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Consumer<Company>(
          builder: (context, company) {
            // Using RepaintBoundary here because this part of the UI
            // changes frequently.
            return RepaintBoundary(
              child: Row(
                children: [
                  Container(width: 125, child: UsersBadge(company.users)),
                  StatSeparator(),
                  Container(width: 125, child: JoyBadge(company.joy)),
                  StatSeparator(),
                  Expanded(child: CoinBadge(company.coin)),
                ],
              ),
            );
          },
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: CharacterPoolPage(),
          ),
          const Expanded(
            child: ThreeColTaskPoolPage(display: TaskPoolDisplay.inProgress),
          ),
          const Expanded(
            child: ThreeColTaskPoolPage(display: TaskPoolDisplay.completed),
          ),
        ],
      ),
    );
  }
}
