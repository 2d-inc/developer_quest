/// Arguments that drive the game from one screen to the next.
class QuestionArguments {
  final List<String> questionRoutes;
  final int currentIndex;

  QuestionArguments({
    this.questionRoutes = const [],
    this.currentIndex = 0,
  });

  bool get hasNextQuestion => currentIndex + 1 != questionRoutes.length;

  String get routeName => questionRoutes[currentIndex];

  QuestionArguments nextQuestion() {
    if (!hasNextQuestion) throw StateError('No next question available');

    return QuestionArguments(
      questionRoutes: questionRoutes,
      currentIndex: currentIndex + 1,
    );
  }
}
