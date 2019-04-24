import 'package:dev_rpg/src/style_sphinx/question_arguments.dart';
import 'package:flutter_test/flutter_test.dart';

/// This test suite demonstrates how you can test business logic independent of
/// the Widget tree.
void main() {
  group('QuestionArguments', () {
    test('should have a next question if one exists', () {
      expect(
        QuestionArguments(questionRoutes: ['a', 'b']).hasNextQuestion,
        isTrue,
      );

      expect(
        QuestionArguments(
          questionRoutes: ['a', 'b', 'c'],
          currentIndex: 1,
        ).hasNextQuestion,
        isTrue,
      );
    });

    test('should not have a next question if one does not exist', () {
      expect(QuestionArguments().hasNextQuestion, isFalse);
      expect(
        QuestionArguments(
          questionRoutes: ['a'],
          currentIndex: 0,
        ).hasNextQuestion,
        isFalse,
      );
    });

    test('should produce next arguments based on the current arguments', () {
      final routes = ['a', 'b'];

      expect(
        QuestionArguments(questionRoutes: routes).nextQuestion(),
        QuestionArguments(questionRoutes: routes, currentIndex: 1),
      );
    });

    test('should throw if the next question does not exist', () {
      expect(
        QuestionArguments().nextQuestion,
        throwsStateError,
      );
    });
  });
}
