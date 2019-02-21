import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/npc_pool.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:flutter/material.dart';

class NpcPoolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<NpcPool>(
      builder: (context, child, npcPool) {
        return ListView.builder(
          itemCount: npcPool.length,
          itemBuilder: (context, index) => ProviderNode(
                providers: Providers.withProviders({
                  Npc: Provider<Npc>.value(npcPool[index]),
                }),
                child: NpcListItem(
                  key: ValueKey(npcPool[index]),
                ),
              ),
        );
      },
    );
  }
}

class NpcListItem extends StatelessWidget {
  NpcListItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provide<Npc>(
      builder: (context, _, npc) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(npc.name),
                Text(npc.isHired ? 'Hired' : 'For hire'),
                Text(npc.isBusy ? 'Busy' : 'Idle'),
              ],
            ),
          ),
        );
      },
    );
  }
}
