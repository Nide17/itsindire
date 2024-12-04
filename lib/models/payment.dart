import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  DateTime? createdAt;
  DateTime? endAt;
  String? userId;
  String? ifatabuguziID;
  int? igiciro;
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
    if (endAt == null) {
      return 0;
    }
    Duration diff = endAt!.difference(now);
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

  // GET REMAINING MINUTES
  int getRemainingMinutes() {
    DateTime now = DateTime.now();
    if (endAt == null) {
      return 0;
    }
    Duration diff = endAt!.difference(now);
    int minutesDifference = diff.inMinutes;

    // Check if there is any remaining time in the day beyond the full days difference
    if (diff.inSeconds % 60 > 0) {
      if (diff.isNegative) {
        minutesDifference -=
            1; // Passed time within a day should be considered as a full day passed
      } else {
        minutesDifference +=
            1; // Remaining time within a day should be considered as a full day remaining
      }
    }
    return minutesDifference < 0 ? 0 : minutesDifference;
  }

  // GET FORMATTED END DATE - 2021-09-30
  String getFormatedEndDate() {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    if (endAt != null) {
      return formatter.format(endAt!);
    } else {
      return 'N/A'; // or any default value you prefer
    }
  }

  String getFormatedEndDateTime() {
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    if (endAt != null) {
      return formatter.format(endAt!);
    } else {
      return 'N/A'; // or any default value you prefer
    }
    }

  String getFormattedCreatedAt() {
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    if (createdAt != null) {
      return formatter.format(createdAt!);
    } else {
      return 'N/A'; // or any default value you prefer
    }
  }

  // FROM JSON
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      endAt: (json['endAt'] as Timestamp).toDate(),
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
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'endAt': endAt != null ? Timestamp.fromDate(endAt!) : null,
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
