
class OptionPopQn {
  int id = 0;
  bool isCorrect = false;
  String title = '';
  String? description = '';

  OptionPopQn({
    required this.id,
    required this.isCorrect,
    required this.title,
    this.description,
  });

  OptionPopQn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isCorrect = json['isCorrect'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isCorrect': isCorrect,
      'title': title,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'OptionPopQn(id: $id, isCorrect: $isCorrect, title: $title, description: $description)';
  }

  OptionPopQn toObject(Map<String, dynamic> map) {
    return OptionPopQn(
      id: map['id'],
      isCorrect: map['isCorrect'],
      title: map['title'],
      description: map['description'],
    );
  }
}

// MODEL TO REPRESENT THE INGINGO
class PopQuestionModel {
  String id = '';
  int ingingoID = 0;
  int isomoID = 0;
  String title = '';
  dynamic options = '';

  // CONSTRUCTOR
  PopQuestionModel({
    required this.id,
    required this.ingingoID,
    required this.isomoID,
    required this.title,
    required this.options,
  });

  // FROM JSON
  PopQuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ingingoID = json['ingingoID'];
    isomoID = json['isomoID'];
    title = json['title'];
    options = json['options'];
  }
  
  int getCorrectOptionId () {
    int correctOptionId = -1;
    for (var i = 0; i < options.length; i++) {
      if (options[i]['isCorrect'] == true) {
        correctOptionId = options[i]['id'];
      }
    }
    return correctOptionId;
  }

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ingingoID': ingingoID,
      'isomoID': isomoID,
      'title': title,
      'options': options,
    };
  }

  // TO STRING
  @override
  String toString() {
    return 'PopQuestionModel(id: $id, ingingoID: $ingingoID, isomoID: $isomoID, title: $title, options: $options)';
  }

  // TO OBJECT
  PopQuestionModel toObject(Map<String, dynamic> map) {
    return PopQuestionModel(
      id: map['id'],
      ingingoID: map['ingingoID'],
      isomoID: map['isomoID'],
      title: map['title'],
      options: map['options'],
    );
  }
}