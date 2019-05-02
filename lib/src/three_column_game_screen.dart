import 'dart:math';

import 'package:dev_rpg/src/game_screen/character_pool_page.dart';
import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/app_bar/coin_badge.dart';
import 'package:dev_rpg/src/widgets/app_bar/joy_badge.dart';
import 'package:dev_rpg/src/widgets/app_bar/stat_separator.dart';
import 'package:dev_rpg/src/widgets/app_bar/users_badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dev_rpg/src/game_screen/task_pool_page.dart';
import 'package:dev_rpg/src/game_screen/three_col_task_pool_page.dart';

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
    var availableWidth = MediaQuery.of(context).size.width;
    var taskColumnWidth = min(modalMaxWidth, availableWidth / 3);
    var charactersWidth = availableWidth - taskColumnWidth * 2;
    var numCharacterColumns =
        max(2, (charactersWidth / idealCharacterWidth).round());

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
                    Container(width: 125, child: UsersBadge(company.users)),
                    StatSeparator(),
                    Container(width: 125, child: JoyBadge(company.joy)),
                    StatSeparator(),
                    Expanded(child: CoinBadge(company.coin)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      body: Row(
        children: [
          SizedBox(
            width: charactersWidth,
            child: CharacterPoolPage(numColumns: numCharacterColumns),
          ),
          SizedBox(
            width: taskColumnWidth,
            child:
                const ThreeColTaskPoolPage(display: TaskPoolDisplay.inProgress),
          ),
          SizedBox(
            width: taskColumnWidth,
            child:
                const ThreeColTaskPoolPage(display: TaskPoolDisplay.completed),
          ),
        ],
      ),
    );
  }
}
