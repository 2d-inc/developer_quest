import 'package:flutter/material.dart';

class QuestionScaffold extends StatelessWidget {
  final Widget question;
  final Widget expected;
  final Widget actual;

  const QuestionScaffold({
    Key key,
    this.question,
    this.expected,
    this.actual,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 216, 204, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 24,
                top: 8,
              ),
              child: question,
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    color: const Color.fromRGBO(252, 235, 227, 1),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 0,
                      bottom: 48,
                    ),
                    child: expected,
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 0,
                      bottom: 48,
                    ),
                    child: actual,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
