/// Arguments that drive the game from one screen to the next.
class SphinxGameState {
  List<String> questionRoutes;
  int currentIndex;

  SphinxGameState({
    this.questionRoutes = const [],
    this.currentIndex = 0,
  });

  bool get hasNextQuestion => currentIndex + 1 != questionRoutes.length;

  String get routeName => questionRoutes[currentIndex];

  void nextQuestion() {
    if (!hasNextQuestion) throw StateError('No next question available');

    currentIndex++;
  }

  void reset() {
    currentIndex = 0;
    questionRoutes = [];
  }
}
