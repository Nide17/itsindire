import 'package:flutter/material.dart';
import 'package:tegura/screens/iga/utils/quiz_score_provider.dart';

class IsuzumeResults extends StatefulWidget {
  // INSTANCE VARIABLES
  final QuizScoreProvider scoreProviderModel;

  const IsuzumeResults({super.key, required this.scoreProviderModel});

  @override
  State<IsuzumeResults> createState() => _IsuzumeResultsState();
}

class _IsuzumeResultsState extends State<IsuzumeResults> {
  @override
  Widget build(BuildContext context) {
    // print('Marks: ${widget.scoreProviderModel.quizScore}');

    // int count = 0;
    // for (ScoreQuestion question
    //     in widget.scoreProviderModel.quizScore.questions) {
    //   // print the count
    //   print('Count: ${count++}');
    // }

    // PRINT THE quizScore
    print(widget.scoreProviderModel.quizScore.questions[1].isAnswerCorrect);

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

    // PRINT THE MARKS
    print('Marks: $marks');

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
