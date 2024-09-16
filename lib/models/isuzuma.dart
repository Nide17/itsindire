class IsuzumaModel {
  String id;
  String title;
  String? description;
  List<IsuzumaQuestion> questions;

  IsuzumaModel({
    required this.id,
    required this.title,
    this.description,
    required this.questions,
  });

  // GET UNIQUE ISOMO IDS FROM ALL QUESTIONS
  List<String> getIsomoIDs() {
    List<String> isomoIDs = [];
    for (var question in questions) {
      if (!isomoIDs.contains(question.isomoID)) {
        isomoIDs.add(question.isomoID);
      }
    }
    return isomoIDs;
  }

  // FROM JSON
  IsuzumaModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        questions = (json['questions'] as List<dynamic>)
            .map((questionJson) => IsuzumaQuestion.fromJson(questionJson))
            .toList();

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions,
    };
  }

  // TO STRING
  @override
  String toString() {
    return 'Isuzuma(id: $id, title: $title, description: $description, questions: $questions)';
  }

  // TO OBJECT
  IsuzumaModel toObject(Map<String, dynamic> map) {
    return IsuzumaModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      questions: map['questions'],
    );
  }
}

class IsuzumaQuestion {
  int id;
  String ingingoID;
  String isomoID;
  String? title;
  String? imageUrl;
  List<IsuzumaOption> options;

  IsuzumaQuestion({
    required this.id,
    required this.ingingoID,
    required this.isomoID,
    this.title,
    this.imageUrl,
    required this.options,
  });

  // FROM JSON
  IsuzumaQuestion.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        ingingoID = json['ingingoID'],
        isomoID = json['isomoID'],
        title = json['title'],
        imageUrl = json['imageUrl'],
        options = (json['options'] as List<dynamic>)
            .map((optionJson) => IsuzumaOption.fromJson(optionJson))
            .toList();

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ingingoID': ingingoID,
      'isomoID': isomoID,
      'title': title,
      'imageUrl': imageUrl,
      'options': options,
    };
  }

  // TO STRING
  @override
  String toString() {
    return 'Question(id: $id, ingingoID: $ingingoID, isomoID: $isomoID, title: $title, imageUrl: $imageUrl, options: $options)';
  }

  // TO OBJECT
  IsuzumaQuestion toObject(Map<String, dynamic> map) {
    return IsuzumaQuestion(
      id: map['id'],
      ingingoID: map['ingingoID'],
      isomoID: map['isomoID'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      options: map['options'],
    );
  }
}

class IsuzumaOption {
  int id;
  String? text;
  String? imageUrl;
  bool isCorrect;
  String? explanation;

  IsuzumaOption({
    required this.id,
    this.text,
    this.imageUrl,
    required this.isCorrect,
    this.explanation,
  });

  // FROM JSON
  IsuzumaOption.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        imageUrl = json['imageUrl'],
        isCorrect = json['isCorrect'],
        explanation = json['explanation'];

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'isCorrect': isCorrect,
      'explanation': explanation,
    };
  }

  // TO STRING
  @override
  String toString() {
    return 'Option(id: $id, text: $text, imageUrl: $imageUrl, isCorrect: $isCorrect, explanation: $explanation)';
  }

  // TO OBJECT
  IsuzumaOption toObject(Map<String, dynamic> map) {
    return IsuzumaOption(
      id: map['id'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      isCorrect: map['isCorrect'],
      explanation: map['explanation'],
    );
  }
}
