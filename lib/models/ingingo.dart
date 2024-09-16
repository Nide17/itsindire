class Option {
  int id = 0;
  String? title;
  String? text;
  String? imageUrl;
  String? imageTitle;
  String? imageDesc;

  Option({
    required this.id,
    this.title,
    this.text,
    this.imageUrl,
    this.imageTitle,
    this.imageDesc,
  });

  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    text = json['text'];
    imageUrl = json['imageUrl'];
    imageTitle = json['imageTitle'];
    imageDesc = json['imageDesc'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'imageUrl': imageUrl,
      'imageTitle': imageTitle,
      'imageDesc': imageDesc,
    };
  }

  @override
  String toString() {
    return '$text';
  }

  Option toObject(Map<String, dynamic> map) {
    return Option(
      id: map['id'],
      title: map['title'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      imageTitle: map['imageTitle'],
      imageDesc: map['imageDesc'],
    );
  }
}

// MODEL TO REPRESENT THE INGINGO
class IngingoModel {
  int id = 0;
  String isomoId = '';
  String? title = '';
  String? text = '';
  String? imageUrl = '';
  String? imageTitle = '';
  String? imageDesc = '';
  dynamic options = '';
  String? nb = '';
  String? insideTitle = '';

  // CONSTRUCTOR
  IngingoModel({
    required this.id,
    required this.isomoId,
    this.title,
    this.text,
    this.imageUrl,
    this.imageTitle,
    this.imageDesc,
    this.options,
    this.nb,
    this.insideTitle,
  });

  // FROM JSON
  IngingoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isomoId = json['isomoId'];
    title = json['title'];
    text = json['text'];
    imageUrl = json['imageUrl'];
    imageTitle = json['imageTitle'];
    imageDesc = json['imageDesc'];
    options = json['options'];
    nb = json['nb'];
    insideTitle = json['insideTitle'];
  }

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isomoId': isomoId,
      'title': title,
      'text': text,
      'imageUrl': imageUrl,
      'imageTitle': imageTitle,
      'imageDesc': imageDesc,
      'options': options,
      'nb': nb,
      'insideTitle': insideTitle,
    };
  }

  // TO STRING
  @override
  String toString() {
    return 'IngingoModel(id: $id, isomoId: $isomoId, title: $title, text: $text, imageUrl: $imageUrl, imageTitle: $imageTitle, imageDesc: $imageDesc, options: $options, nb: $nb, insideTitle: $insideTitle)';
  }

  // TO OBJECT
  IngingoModel toObject(Map<String, dynamic> map) {
    return IngingoModel(
      id: map['id'],
      isomoId: map['isomoId'],
      title: map['title'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      imageTitle: map['imageTitle'],
      imageDesc: map['imageDesc'],
      options: map['options'],
      nb: map['nb'],
      insideTitle: map['insideTitle'],
    );
  }
}

// REPRESENTS THE SUM OF THE INGINGOS
class IngingoSum {
  int sum = 0;

  IngingoSum({required this.sum});

  @override
  String toString() {
    return '$sum';
  }

  int toObject(Map<String, dynamic> map) {
    return map['sum'];
  }
}

