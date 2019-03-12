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
      itemCount: npcPool.length,
      itemBuilder: (context, index) => ChangeNotifierProvider<Npc>(
            notifier: npcPool[index],
            key: ValueKey(npcPool[index]),
            child: NpcListItem(),
          ),
    );
  }
}

/// Displays the current state of an individual [Npc]
/// Tapping on the [Npc] opens up a modal window which
/// offers more details about stats and options to upgrade.
class NpcListItem extends StatelessWidget {
  NpcListItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var npc = Provider.of<Npc>(context);
    return Card(
        child: InkWell(
      onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            // TODO: return object of type Dialog
            return NpcModal(npc: npc);
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
            SizedBox(height: 5),
            ProwessBadge(npc.prowess),
            SizedBox(height: 10)
          ],
        ),
      ),
    ));
  }
}
