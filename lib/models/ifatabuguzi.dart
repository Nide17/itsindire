class IfatabuguziModel {
  String id = '';
  String igihe;
  int igiciro;
  List<String> ibirimo;
  String ubusobanuro;

  IfatabuguziModel({
    required this.id,
    required this.igihe,
    required this.igiciro,
    required this.ibirimo,
    required this.ubusobanuro,
  });

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

    if (igihe == 'umunsi 1 (Kwipima)') {
      nbr = 1;
    } else if (igihe == 'icyumweru') {
      nbr = 7;
    } else if (igihe == 'ukwezi') {
      nbr = thisMonthDays;
    } else if (igihe == 'amezi 2') {
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
        ubusobanuro = json['ubusobanuro'];

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'igihe': igihe,
      'igiciro': igiciro,
      'ibirimo': ibirimo.join('\n'),
      'ubusobanuro': ubusobanuro,
    };
  }

  @override
  String toString() {
    return 'Ifatabuguzi(id: $id, igihe: $igihe, igiciro: $igiciro, ibirimo: $ibirimo, ubusobanuro: $ubusobanuro)';
  }

  IfatabuguziModel copyWith({
    String? id,
    String? igihe,
    int? igiciro,
    List<String>? ibirimo,
    String? ubusobanuro,
  }) {
    return IfatabuguziModel(
      id: id ?? this.id,
      igihe: igihe ?? this.igihe,
      igiciro: igiciro ?? this.igiciro,
      ibirimo: ibirimo ?? this.ibirimo,
      ubusobanuro: ubusobanuro ?? this.ubusobanuro,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'igihe': igihe,
      'igiciro': igiciro,
      'ibirimo': ibirimo.join('\n'),
      'ubusobanuro': ubusobanuro,
    };
  }

  factory IfatabuguziModel.fromMap(Map<String, dynamic> map) {
    return IfatabuguziModel(
      id: map['id'],
      igihe: map['igihe'],
      igiciro: map['igiciro'],
      ibirimo: List<String>.from(map['ibirimo'].split('\n')),
      ubusobanuro: map['ubusobanuro'],
    );
  }
}
