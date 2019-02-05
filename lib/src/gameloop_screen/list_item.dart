import 'package:dev_rpg/src/shared_state/game/quest.dart';
import 'package:dev_rpg/src/shared_state/game/teams.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:flutter/material.dart';

class QuestListItem extends StatelessWidget {
  final Quest quest;

  QuestListItem({Key key, @required this.quest})
      : assert(quest != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () => Provide.value<Teams>(context).single.assignTo(quest),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(quest.name, style: Theme.of(context).textTheme.title),
            SizedBox(height: 20),
            LinearProgressIndicator(value: quest.percentComplete),
          ],
        ),
      ),
    );
  }
}
