import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('world can be started', (WidgetTester tester) async {
    var buttonKey = const ValueKey('start');

    await tester.pumpWidget(
      ChangeNotifierProvider(
        builder: (_) => World(),
        child: MaterialApp(
          home: Consumer<World>(
            builder: (context, world, child) => FlatButton(
                  key: buttonKey,
                  onPressed: () => world.start(),
                  child: Text(world.isRunning ? 'Stop' : 'Start'),
                ),
          ),
        ),
      ),
    );

    expect(find.text('Stop'), findsNothing);
    await tester.tap(find.byKey(buttonKey));
    await tester.pumpAndSettle();
    expect(find.text('Stop'), findsOneWidget);
  });
}
