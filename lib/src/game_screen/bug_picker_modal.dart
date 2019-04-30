import 'package:dev_rpg/src/shared_state/game/bug.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/work_items/bug_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a list of the currently available [Bug]s.
class BugPickerModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var taskPool = Provider.of<TaskPool>(context);
    var bugs = taskPool.availableBugs.toList(growable: false)
      ..sort((a, b) => -a.priority.drainOfJoy.compareTo(b.priority.drainOfJoy));

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: modalMaxWidth),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          child: Container(
            color: modalBackgroundColor,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              itemCount: bugs.length,
              itemBuilder: (context, index) {
                Bug bug = bugs[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: () => Navigator.pop(context, bug),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.03),
                              offset: Offset(0, 10),
                              blurRadius: 10,
                              spreadRadius: 0),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BugHeader(bug),
                          const SizedBox(height: 12),
                          Text(bug.name, style: contentStyle)
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
