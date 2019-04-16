import 'package:dev_rpg/src/game_screen/npc_modal.dart';
import 'package:dev_rpg/src/game_screen/npc_style.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/npc_pool.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/flare/hiring_bust.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a list of [Npc]s that are available to the player.
class NpcPoolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var npcPool = Provider.of<NpcPool>(context);
    return Stack(
      children: [
        GridView.builder(
          padding:
              const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 128.0),
          itemCount: npcPool.children.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 15.0,
              childAspectRatio: 0.65),
          itemBuilder: (context, index) => ChangeNotifierProvider<Npc>(
                notifier: npcPool.children[index],
                key: ValueKey(npcPool.children[index]),
                child: NpcListItem(),
              ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 1.0,
            child: Container(
              height: 128,
              decoration: BoxDecoration(
                // Box decoration takes a gradient
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(59, 59, 73, 0.0),
                    Color.fromRGBO(59, 59, 73, 1.0)
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
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

    HiringBustState bustState = npc.isHired
        ? HiringBustState.hired
        : npc.canUpgrade ? HiringBustState.available : HiringBustState.locked;

    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromRGBO(69, 69, 82, 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10.0,
                ),
              ],
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onTap: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return ChangeNotifierProvider<Npc>(
                      notifier: npc,
                      child: NpcModal(),
                    );
                  }),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: HiringBust(
                    particleColor: attentionColor,
                    filename: npcStyle.flare,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    hiringState: bustState,
                  )),
                  const SizedBox(height: 20.0),
                  Opacity(
                    opacity: npc.isHired || npc.canUpgrade ? 1.0 : 0.25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        npc.isHired
                            ? Container()
                            : Icon(
                                bustState == HiringBustState.available
                                    ? Icons.add_circle
                                    : Icons.lock,
                                color: !npc.isHired && npc.canUpgrade
                                    ? attentionColor
                                    : Colors.white),
                        const SizedBox(width: 4.0),
                        Text(
                          bustState == HiringBustState.hired
                              ? 'Hired'
                              : bustState == HiringBustState.available
                                  ? 'Hire!'
                                  : 'Locked',
                          style: contentStyle.apply(
                              color: bustState == HiringBustState.available
                                  ? attentionColor
                                  : Colors.white),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
