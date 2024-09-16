class PaymentModel {
  String? id;
  DateTime createdAt;
  DateTime endAt;
  String? userId;
  String? ifatabuguziID;
  String? igiciro;
  bool? isApproved;
  String? phone;

  PaymentModel({
    this.id,
    required this.createdAt,
    required this.endAt,
    this.userId,
    this.ifatabuguziID,
    this.igiciro,
    this.isApproved,
    this.phone,
  });

  // GET REMAINING DAYS
  int getRemainingDays() {
    // GET THE CURRENT DATE
    DateTime now = DateTime.now();

    // GET THE DIFFERENCE
    int diff = endAt.difference(now).inDays;

    // RETURN THE DIFFERENCE
    return diff + 1;
  }

  // GET FORMATED END DATE - 2021-09-30
  String getFormatedEndDate() {
    // GET THE END DATE
    DateTime end = endAt;

    // FORMAT THE END DATE
    String formatedEnd = '${end.day}-${end.month}-${end.year}';

    // RETURN THE FORMATED END DATE
    return formatedEnd;
  }

  // FROM JSON
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      createdAt: json['createdAt'].toDate(),
      endAt: json['endAt'].toDate(),
      userId: json['userId'],
      ifatabuguziID: json['ifatabuguziID'],
      igiciro: json['igiciro'],
      isApproved: json['isApproved'],
      phone: json['phone'],
    );
  }

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'endAt': endAt,
      'userId': userId,
      'ifatabuguziID': ifatabuguziID,
      'igiciro': igiciro,
      'isApproved': isApproved,
      'phone': phone,
    };
  }

  // TO STRING
  @override
  String toString() {
    return 'PaymentModel(id: $id, createdAt: $createdAt, endAt: $endAt, userId: $userId, ifatabuguziID: $ifatabuguziID, igiciro: $igiciro, isApproved: $isApproved, phone: $phone)';
  }
}
