// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dev_rpg/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Start the game', (WidgetTester tester) async {
    final startFinder = find.text('START');

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Find the start text
    expect(startFinder, findsOneWidget);

    // Start the game.
    expect(find.byType(FlatButton), findsNWidgets(2));
    await tester.tap(startFinder);

    // Need to pump twice instead of use pumpAndSettle, because pumpAndSettle
    // will wait for all animations to complete. Because there are looping
    // animations on the main screen, pumpAndSettle will never succeed.
    await tester.pump();
    await tester.pump();

    expect(find.text('Tasks'), findsOneWidget);
  });
}
