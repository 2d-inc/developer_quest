import 'package:dev_rpg/src/game_screen/npc_modal.dart';
import 'package:dev_rpg/src/game_screen/prowess_badge.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/npc_pool.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a list of [Npc]s that are available to the player.
class NpcPoolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var npcPool = Provider.of<NpcPool>(context);
    return ListView.builder(
      itemCount: npcPool.children.length,
      itemBuilder: (context, index) => ChangeNotifierProvider<Npc>(
            notifier: npcPool.children[index],
            key: ValueKey(npcPool.children[index]),
            child: NpcListItem(),
          ),
    );
  }
}

/// Displays the current state of an individual [Npc]
/// Tapping on the [Npc] opens up a modal window which
/// offers more details about stats and options to upgrade.
class NpcListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var npc = Provider.of<Npc>(context);
    return Card(
        child: InkWell(
      onTap: () => showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return ChangeNotifierProvider<Npc>(
              notifier: npc,
              child: NpcModal(),
            );
          }),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(npc.name),
                Text(npc.isHired ? 'Hired' : 'For hire'),
                Text(npc.isBusy ? 'Busy' : 'Idle'),
              ],
            ),
            const SizedBox(height: 5),
            ProwessBadge(npc.prowess),
            const SizedBox(height: 10)
          ],
        ),
      ),
    ));
  }
}
