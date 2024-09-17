class IfatabuguziModel {
  String id = '';
  String igihe;
  int igiciro;
  List<String> ibirimo;
  String ubusobanuro;
  String type;

  IfatabuguziModel(
      {required this.id,
      required this.igihe,
      required this.igiciro,
      required this.ibirimo,
      required this.ubusobanuro,
      required this.type});

  // GET DAYS
  int getDays() {
    int nbr;
    int thisMonthDays = DateTime.now().month == 2
        ? 28
        : DateTime.now().month == 4 ||
                DateTime.now().month == 6 ||
                DateTime.now().month == 9 ||
                DateTime.now().month == 11
            ? 30
            : 31;

    if (igihe == 'umunsi 1 (Kwipima)' || igihe == 'One day (Quizzes)') {
      nbr = 1;
    } else if (igihe == 'icyumweru' || igihe == 'Full week') {
      nbr = 7;
    } else if (igihe == 'ukwezi' || igihe == 'Full month') {
      nbr = thisMonthDays;
    } else if (igihe == 'amezi 2' || igihe == '2 months full') {
      nbr = (thisMonthDays * 2) - 1;
    } else {
      nbr = 0;
    }

    // RETURN THE DIFFERENCE
    return nbr;
  }

  // CALCULATE END DATE
  DateTime getEndDate() {
    // GET THE CURRENT DATE
    DateTime now = DateTime.now();

    // GET THE END DATE
    DateTime end = now.add(Duration(days: getDays()));

    // RETURN THE END DATE
    return end;
  }

  // FROM JSON
  IfatabuguziModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        igihe = json['igihe'],
        igiciro = json['igiciro'],
        ibirimo = List<String>.from(json['ibirimo'].split('\n')),
        ubusobanuro = json['ubusobanuro'],
        type = json['type'];

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'igihe': igihe,
      'igiciro': igiciro,
      'ibirimo': ibirimo.join('\n'),
      'ubusobanuro': ubusobanuro,
      'type': type
    };
  }

  @override
  String toString() {
    return 'Ifatabuguzi(id: $id, igihe: $igihe, igiciro: $igiciro, ibirimo: $ibirimo, ubusobanuro: $ubusobanuro, type: $type)';
  }

  IfatabuguziModel copyWith({
    String? id,
    String? igihe,
    int? igiciro,
    List<String>? ibirimo,
    String? ubusobanuro,
    String? type,
  }) {
    return IfatabuguziModel(
      id: id ?? this.id,
      igihe: igihe ?? this.igihe,
      igiciro: igiciro ?? this.igiciro,
      ibirimo: ibirimo ?? this.ibirimo,
      ubusobanuro: ubusobanuro ?? this.ubusobanuro,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'igihe': igihe,
      'igiciro': igiciro,
      'ibirimo': ibirimo.join('\n'),
      'ubusobanuro': ubusobanuro,
      'type': type
    };
  }

  factory IfatabuguziModel.fromMap(Map<String, dynamic> map) {
    return IfatabuguziModel(
      id: map['id'],
      igihe: map['igihe'],
      igiciro: map['igiciro'],
      ibirimo: List<String>.from(map['ibirimo'].split('\n')),
      ubusobanuro: map['ubusobanuro'],
      type: map['type'],
    );
  }
}
