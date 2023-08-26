import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IsuzumaScoreModel extends ChangeNotifier {
  String id;
  String isuzumaID;
  String takerID;
  int marks;
  int totalMarks;
  DateTime dateTaken;
  List<ScoreQuestionI> questions;
  List<String>? amasomo = []; // LIST OF AMASOMO IDS
  String? isuzumaTitle = ''; // ISUZUMA TITLE

  IsuzumaScoreModel({
    required this.id,
    required this.isuzumaID,
    required this.takerID,
    required this.marks,
    required this.totalMarks,
    required this.dateTaken,
    required this.questions,
    required this.amasomo,
    required this.isuzumaTitle,
  });

  int calculateMarks() {
    int marks = 0;
    for (var question in questions) {
      if (question.isAnswered == true) {
        for (var option in question.options) {
          if (option.isChoosen == true && option.isCorrect == true) {
            marks++;
          }
        }
      }
    }
    return marks;
  }

  void setIsAnswered(int questionID) {
    for (var question in questions) {
      if (question.id == questionID && question.isAnswered == false) {
        question.isAnswered = true;
        // This call tells the widgets that are listening to this model to rebuild.
        notifyListeners();
        break;
      } else {
        print('Not set to answered!');
      }
    }
  }

  void setAnswerOption(int questionID, int optionID) {
    for (var question in questions) {
      if (question.id == questionID) {
        question.setIsChoosen(optionID);
        // This call tells the widgets that are listening to this model to rebuild.
        notifyListeners();
        break;
      }
    }

    // SET setIsAnswered FOR THE QUESTION
    setIsAnswered(questionID);
  }

  bool isThisAnswerOptionChoosen(int questionID, int optionID) {
    for (var question in questions) {
      if (question.id == questionID) {
        return question.isThisOptionChoosen(optionID);
      }
    }
    return false;
  }

  bool isAnsweredCorrectly(int questionID) {
    for (var question in questions) {
      if (question.id == questionID) {
        return question.isCorrectChoosen();
      }
    }
    return false;
  }

  // FROM JSON
  IsuzumaScoreModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        isuzumaID = json['isuzumaID'],
        takerID = json['takerID'],
        marks = json['marks'],
        totalMarks = json['totalMarks'],
        dateTaken = (json['dateTaken'] as Timestamp).toDate(),
        questions = (json['questions'] as List)
            .map((questionJson) => ScoreQuestionI.fromJson(questionJson))
            .toList(),
        amasomo = json['amasomo']?.cast<String>(),
        isuzumaTitle = json['isuzumaTitle'];

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isuzumaID': isuzumaID,
      'takerID': takerID,
      'marks': marks,
      'totalMarks': totalMarks,
      'dateTaken': dateTaken,
      'questions': questions.map((question) => question.toJson()).toList(),
      'amasomo': amasomo,
      'isuzumaTitle': isuzumaTitle,
    };
  }

  // TO STRING
  @override
  String toString() {
    return 'IsuzumaScoreModel(id: $id, isuzumaID: $isuzumaID, takerID: $takerID, marks: $marks, totalMarks: $totalMarks, dateTaken: $dateTaken, questions: $questions, amasomo: $amasomo, isuzumaTitle: $isuzumaTitle)';
  }

  // TO OBJECT
  IsuzumaScoreModel toObject(Map<String, dynamic> map) {
    return IsuzumaScoreModel(
      id: map['id'],
      isuzumaID: map['isuzumaID'],
      takerID: map['takerID'],
      marks: map['marks'],
      totalMarks: map['totalMarks'],
      dateTaken: map['dateTaken'],
      questions: map['questions'],
      amasomo: map['amasomo'],
      isuzumaTitle: map['isuzumaTitle'],
    );
  }

  void saveScore() {}
}

// TO MAP
class ScoreQuestionI {
  int id;
  String ingingoID;
  String isomoID;
  String? title;
  String? image;
  List<ScoreOptionI> options;
  bool isAnswered;

  ScoreQuestionI({
    required this.id,
    required this.ingingoID,
    required this.isomoID,
    this.title,
    this.image,
    required this.options,
    this.isAnswered = false,
  });

  bool isQnAnswered() {
    for (var option in options) {
      if (option.isChoosen == true && isAnswered == true) {
        return true;
      }
    }
    return false;
  }

  bool isThisOptionChoosen(int optionID) {
    for (var option in options) {
      if (option.id == optionID) {
        return option.isChoosen!;
      }
    }
    return false;
  }

  bool isCorrectChoosen() {
    for (var option in options) {
      if (option.isChoosen == true && option.isCorrect == true) {
        return true;
      }
    }
    return false;
  }

  // SET IS CHOOSEN FOR QUESTION OPTIONS
  void setIsChoosen(int optionID) {
    for (var option in options) {
      if (option.id == optionID) {
        option.isChoosen = true;
      } else {
        option.isChoosen = false;
      }
    }
  }
  

  // TO STRING
  @override
  String toString() {
    return 'ScoreQuestionI(id: $id, ingingoID: $ingingoID, isomoID: $isomoID, title: $title, image: $image, options: $options, isAnswered: $isAnswered)';
  }

  // FROM JSON
  factory ScoreQuestionI.fromJson(Map<String, dynamic> json) {
    return ScoreQuestionI(
      id: json['id'],
      ingingoID: json['ingingoID'],
      isomoID: json['isomoID'],
      title: json['title'],
      image: json['image'],
      options: (json['options'] as List)
          .map((optionJson) => ScoreOptionI.fromJson(optionJson))
          .toList(),
      isAnswered: json['isAnswered'],
    );
  }

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ingingoID': ingingoID,
      'isomoID': isomoID,
      'title': title,
      'image': image,
      'options': options.map((option) => option.toJson()).toList(),
      'isAnswered': isAnswered,
    };
  }

  // TO OBJECT
  ScoreQuestionI toObject(Map<String, dynamic> map) {
    return ScoreQuestionI(
      id: map['id'],
      ingingoID: map['ingingoID'],
      isomoID: map['isomoID'],
      title: map['title'],
      image: map['image'],
      options: map['options'],
      isAnswered: map['isAnswered'],
    );
  }
}

class ScoreOptionI {
  int id;
  String? text;
  String? explanation;
  String? image;
  bool isCorrect;
  bool? isChoosen;

  ScoreOptionI({
    required this.id,
    this.text,
    this.explanation,
    this.image,
    required this.isCorrect,
    this.isChoosen,
  });

  // FROM JSON
  factory ScoreOptionI.fromJson(Map<String, dynamic> json) {
    return ScoreOptionI(
      id: json['id'],
      text: json['text'],
      explanation: json['explanation'],
      image: json['image'],
      isCorrect: json['isCorrect'],
      isChoosen: json['isChoosen'],
    );
  }

// TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'explanation': explanation,
      'image': image,
      'isCorrect': isCorrect,
      'isChoosen': isChoosen,
    };
  }

  // TO STRING
  @override
  String toString() {
    return 'Option(id: $id, text: $text, explanation: $explanation, image: $image, isCorrect: $isCorrect, isChoosen: $isChoosen)';
  }

  // TO OBJECT
  ScoreOptionI toObject(Map<String, dynamic> map) {
    return ScoreOptionI(
      id: map['id'],
      text: map['text'],
      explanation: map['explanation'],
      image: map['image'],
      isCorrect: map['isCorrect'],
      isChoosen: map['isChoosen'],
    );
  }
}
