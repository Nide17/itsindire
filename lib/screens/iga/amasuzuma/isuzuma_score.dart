import 'package:flutter/material.dart';
import 'package:tegura/providers/quiz_score_provider.dart';

class IsuzumaScore extends StatefulWidget {
  final QuizScoreProvider scoreProviderModel;

  const IsuzumaScore({super.key, required this.scoreProviderModel});

  @override
  State<IsuzumaScore> createState() => _IsuzumaScoreState();
}

class _IsuzumaScoreState extends State<IsuzumaScore> {
  @override
  Widget build(BuildContext context) {
    // MARKS COUNTING
    int marks = 0;

    // LOOP THROUGH THE QUESTIONS
    for (var element in widget.scoreProviderModel.quizScore.questions) {
      // CHECK IF THE ANSWER IS CORRECT
      if (element.isAnswerCorrect != null && element.isAnswerCorrect!) {
        // INCREMENT THE MARKS
        marks++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Isuzume Results'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your Score: $marks',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Percentage: ${(marks / widget.scoreProviderModel.quizScore.questions.length) * 100}%',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
