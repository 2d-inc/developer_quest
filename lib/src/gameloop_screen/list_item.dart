import 'package:dev_rpg/src/shared_state/game/quest.dart';
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
      child: Column(
        children: [
          Text(quest.name, style: Theme.of(context).textTheme.title),
          LinearProgressIndicator(value: quest.percentComplete),
        ],
      ),
    );
  }
}
