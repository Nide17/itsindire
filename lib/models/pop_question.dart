class OptionPopQn {
  int id = 0;
  bool isCorrect = false;
  String? title = '';
  String? text = '';
  String? imageUrl = '';
  String? description = '';

  OptionPopQn({
    required this.id,
    required this.isCorrect,
    this.title,
    this.text,
    this.imageUrl,
    this.description,
  });

  OptionPopQn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isCorrect = json['isCorrect'];
    title = json['title'];
    text = json['text'];
    imageUrl = json['imageUrl'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isCorrect': isCorrect,
      'title': title,
      'text': text,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'OptionPopQn(id: $id, isCorrect: $isCorrect, title: $title, text: $text, imageUrl: $imageUrl, description: $description)';
  }

  OptionPopQn toObject(Map<String, dynamic> map) {
    return OptionPopQn(
      id: map['id'],
      isCorrect: map['isCorrect'],
      title: map['title'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      description: map['description'],
    );
  }
}

// MODEL TO REPRESENT THE INGINGO
class PopQuestionModel {
  String id = '';
  int ingingoID = 0;
  int isomoID = 0;
  String? title = '';
  String? imageUrl = '';
  List<OptionPopQn> options = [];

  PopQuestionModel({
    required this.id,
    required this.ingingoID,
    required this.isomoID,
    this.title,
    this.imageUrl,
    required this.options,
  });

  // FROM JSON
  PopQuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ingingoID = json['ingingoID'];
    isomoID = json['isomoID'];
    title = json['title'];
    imageUrl = json['imageUrl'];
    options = (json['options'] as List<dynamic>)
        .map((optionJson) => OptionPopQn.fromJson(optionJson))
        .toList();
  }

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
    return 'PopQuestion(id: $id, ingingoID: $ingingoID, isomoID: $isomoID, title: $title, imageUrl: $imageUrl, options: $options)';
  }

  // TO OBJECT
  PopQuestionModel toObject(Map<String, dynamic> map) {
    return PopQuestionModel(
      id: map['id'],
      ingingoID: map['ingingoID'],
      isomoID: map['isomoID'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      options: map['options'],
    );
  }

  int getCorrectOptionId() {
    int correctOptionId = -1;
    for (var i = 0; i < options.length; i++) {
      if (options[i].isCorrect) {
        correctOptionId = options[i].id;
        break;
      }
    }
    return correctOptionId;
  }
}
