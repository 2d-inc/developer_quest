import 'package:dev_rpg/src/style_sphinx/sphinx_buttton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// This test suite demonstrates how you can test your own custom Widgets
void main() {
  group('SphinxButton', () {
    testWidgets('displays the child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SphinxButton(
            onPressed: () {},
            child: const Text('A'),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('executes a callback on press', (tester) async {
      int count = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: SphinxButton(
            onPressed: () => count++,
            child: const Text('A'),
          ),
        ),
      );

      await tester.tap(find.text('A'));

      expect(count, 1);
    });
  });
}
