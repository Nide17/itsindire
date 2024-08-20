import 'package:flutter/material.dart';
import 'package:itsindire/models/pop_question.dart';

class QuizScoreProvider extends ChangeNotifier {
  final QuizScore quizScore = QuizScore(
    questions: [],
    userID: '',
    isomoID: 0,
  );
}

// SCORE QUESTION OBJECT: POP QUESTION, isAnswered, ISRIGHT
class QuizScore {
  String userID = '';
  int isomoID = 0;
  List<ScoreQuestion> questions = [];

  QuizScore(
      {required this.questions, required this.userID, required this.isomoID});

  // SETTERS
  void setUserID(String userID) {
    this.userID = userID;
  }

  void setIsomoID(int isomoID) {
    this.isomoID = isomoID;
  }

  // ADD A QUESTION TO THE QUESTIONS ARRAY
  void addQuestion(ScoreQuestion question) {
    questions.add(question);
  }

  // CHANGE THE ISANSWERED STATUS OF THE QUESTION
  void changeIsAnsweredStatus(String questionID, bool isAnswered) {
    // FIND THE QUESTION IN THE QUESTIONS ARRAY AND UPDATE IT
    for (var i = 0; i < questions.length; i++) {
      if (questions[i].getPopQuestion().id == questionID) {
        questions[i].isAnswered = isAnswered;
      }
    }
  }

  bool getIsAtleastOneAnswered() {
    for (var i = 0; i < questions.length; i++) {
      if (questions[i].isAnswered) {
        return true;
      }
    }
    return false;
  }

  bool isAllAnswered() {
    for (var i = 0; i < questions.length; i++) {
      if (!questions[i].isAnswered) {
        return false;
      }
    }
    return true;
  }

  int getCorrectlyAnsweredQuestionsCount() {
    int count = 0;
    for (var i = 0; i < questions.length; i++) {
      if (questions[i].isAnswerCorrect == true) {
        count++;
      }
    }
    return count;
  }

  // TO STRING
  @override
  String toString() {
    return '\nQuizScore{userID: $userID, isomoID: $isomoID, questions: $questions}\n\n';
  }
}

// SCORE QUESTION OBJECT: POP QUESTION, isAnswered, ISRIGHT
class ScoreQuestion {
  final PopQuestionModel popQuestion;
  bool isAnswered;
  bool? isAnswerCorrect;
  int? choosenOption = -1;

  ScoreQuestion(
      {required this.popQuestion,
      required this.isAnswered,
      required this.isAnswerCorrect,
      this.choosenOption});

  // GETTERS
  PopQuestionModel getPopQuestion() {
    return popQuestion;
  }

  // SETTERS
  void setIsAnswerCorrect(bool isAnswerCorrect) {
    this.isAnswerCorrect = isAnswerCorrect;
  }

  void setChoosenOption(int choosenOption) {
    this.choosenOption = choosenOption;
  }

  // TO STRING
  @override
  String toString() {
    return 'ScoreQuestion{popQuestion: $popQuestion, isAnswered: $isAnswered, isAnswerCorrect: $isAnswerCorrect, choosenOption: $choosenOption}';
  }
}
