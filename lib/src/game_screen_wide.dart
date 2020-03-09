import 'dart:math';

import 'package:dev_rpg/src/game_screen/character_pool_page.dart';
import 'package:dev_rpg/src/rpg_layout_builder.dart';
import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/app_bar/coin_badge.dart';
import 'package:dev_rpg/src/widgets/app_bar/joy_badge.dart';
import 'package:dev_rpg/src/widgets/app_bar/stat_separator.dart';
import 'package:dev_rpg/src/widgets/app_bar/users_badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_screen/task_pool_page.dart';

class GameScreenWide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var availableWidth = MediaQuery.of(context).size.width;
    var taskColumnWidth = min(modalMaxWidth, availableWidth / 3);
    var charactersWidth = availableWidth - taskColumnWidth * 2;
    var numCharacterColumns =
        (charactersWidth / idealCharacterWidth).round().clamp(2, 4).toInt();

    return RpgLayoutBuilder(
      builder: (context, layout) {
        double statsScale = layout == RpgLayout.ultrawide ? 1.25 : 1;
        double statsWidth = layout == RpgLayout.ultrawide ? 300 : 125;
        return Scaffold(
          backgroundColor: const Color.fromRGBO(59, 59, 73, 1),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Consumer<Company>(
              builder: (context, company, _) {
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
                        Container(
                          width: statsWidth,
                          child: UsersBadge(
                            company.users,
                            scale: statsScale,
                            isWide: layout == RpgLayout.ultrawide,
                          ),
                        ),
                        StatSeparator(),
                        Container(
                          width: statsWidth,
                          child: JoyBadge(
                            company.joy,
                            scale: statsScale,
                            isWide: layout == RpgLayout.ultrawide,
                          ),
                        ),
                        StatSeparator(),
                        layout == RpgLayout.ultrawide
                            ? Container(
                                width: statsWidth,
                                child: CoinBadge(
                                  company.coin,
                                  scale: statsScale,
                                  isWide: layout == RpgLayout.ultrawide,
                                ),
                              )
                            : Expanded(
                                child:
                                    CoinBadge(company.coin, scale: statsScale)),
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
                child:
                    CharacterPoolPage(numColumns: numCharacterColumns.toInt()),
              ),
              SizedBox(
                width: taskColumnWidth,
                child: const TaskPoolPage(display: TaskPoolDisplay.inProgress),
              ),
              SizedBox(
                width: taskColumnWidth,
                child: const TaskPoolPage(display: TaskPoolDisplay.completed),
              ),
            ],
          ),
        );
      },
    );
  }
}
