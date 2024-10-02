class PaymentModel {
  DateTime createdAt;
  DateTime endAt;
  String? userId;
  String? ifatabuguziID;
  String? igiciro;
  bool? isApproved;
  String? phone;

  PaymentModel({
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
    DateTime now = DateTime.now();
    Duration diff = endAt.difference(now);
    int daysDifference = diff.inDays;

    // Check if there is any remaining time in the day beyond the full days difference
    if (diff.inHours % 24 > 0 ||
        diff.inMinutes % 1440 > 0 ||
        diff.inSeconds % 86400 > 0) {
      if (diff.isNegative) {
        daysDifference -=
            1; // Passed time within a day should be considered as a full day passed
      } else {
        daysDifference +=
            1; // Remaining time within a day should be considered as a full day remaining
      }
    }
    return daysDifference;
  }

  // GET FORMATED END DATE - 2021-09-30
  String getFormatedEndDate() {
    DateTime end = endAt;
    String formatedEnd = '${end.day}-${end.month}-${end.year}';
    return formatedEnd;
  }

  String getFormatedEndDateTime() {
    DateTime end = endAt;
    String formatedEnd =
        '${end.day}-${end.month}-${end.year} ${end.hour}:${end.minute}';
    return formatedEnd;
  }

  // FROM JSON
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
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
    return 'PaymentModel(createdAt: $createdAt, endAt: $endAt, userId: $userId, ifatabuguziID: $ifatabuguziID, igiciro: $igiciro, isApproved: $isApproved, phone: $phone)';
  }
}
