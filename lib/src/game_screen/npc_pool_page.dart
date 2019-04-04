import 'package:dev_rpg/src/game_screen/npc_modal.dart';
import 'package:dev_rpg/src/game_screen/npc_style.dart';
import 'package:dev_rpg/src/game_screen/prowess_badge.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/npc_pool.dart';
import 'package:dev_rpg/src/widgets/flare/hiring_bust.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a list of [Npc]s that are available to the player.
class NpcPoolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var npcPool = Provider.of<NpcPool>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: GridView.builder(
        itemCount: npcPool.children.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 15.0,
            childAspectRatio: 0.75),
        itemBuilder: (context, index) => ChangeNotifierProvider<Npc>(
              notifier: npcPool.children[index],
              key: ValueKey(npcPool.children[index]),
              child: NpcListItem(),
            ),
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
    var npcStyle = NpcStyle.from(npc);
    return Card(
        margin: const EdgeInsets.only(top: 15.0),
        color: const Color.fromRGBO(69, 69, 82, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
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
              children: [
                Expanded(
                    child: HiringBust(
                      filename: npcStyle.flare,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      hiringState: HiringBustState.locked,
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child:
                        Text(npcStyle.name, style: TextStyle(fontSize: 16.0))),
                Text(npc.isHired ? 'Hired' : 'For hire'),
                Text(npc.isBusy ? 'Busy' : 'Idle'),
              ],
            ),
          ),
        ));
  }
}
