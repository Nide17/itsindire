import 'package:tegura/models/pop_question.dart';

class PopQnService {
  static final PopQnService _instance = PopQnService._internal();

  // passes the instantiation to the _instance object
  factory PopQnService() => _instance;

  int _myVariable;
  List<PopQuestionModel>? _popQuestions;

  // private constructor
  PopQnService._internal() : _popQuestions = [], _myVariable = 0 {
    print('PopQnService initialized');
  }
  
  //short getter for my variable
  int get myVariable => _myVariable;

  //short setter for my variable
  set myVariable(int value) => myVariable = value;

  //short getter for popQuestions
  List<PopQuestionModel>? get popQuestions => _popQuestions;

  //short setter for popQuestions
  set popQuestions(List<PopQuestionModel>? value) => _popQuestions = value;

  //short method to increment my variable
  void incrementMyVariable() => _myVariable++;

  //short method to decrement my variable
  void decrementMyVariable() => _myVariable--;

  //short method to reset my variable
  void resetMyVariable() => _myVariable = 0;

  //short method to add a pop question
  void addPopQuestion(PopQuestionModel popQuestion) =>
      _popQuestions!.add(popQuestion);

  //short method to remove a pop question
  void removePopQuestion(PopQuestionModel popQuestion) =>
      _popQuestions!.remove(popQuestion);

  //short method to reset pop questions
  void resetPopQuestions() => _popQuestions = [];

  //short method to get the number of pop questions
  int getPopQuestionsLength() => _popQuestions!.length;

  //short method to get a pop question
  PopQuestionModel getPopQuestion(int index) => _popQuestions![index];

  //short method to get the pop questions
  List<PopQuestionModel>? getPopQuestions() => _popQuestions;

  //short method to set the pop questions
  void setPopQuestions(List<PopQuestionModel>? popQuestions) =>
      _popQuestions = popQuestions;
}
