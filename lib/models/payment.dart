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

  int getRemainingDays() {
    if (endAt == null) return 0;
    Duration diff = endAt!.difference(DateTime.now());
    return diff.isNegative ? 0 : diff.inDays;
  }

  int getRemainingHours() {
    if (endAt == null) return 0;
    Duration diff = endAt!.difference(DateTime.now());
    return diff.isNegative ? 0 : diff.inHours;
  }

  int getRemainingMinutes() {
    if (endAt == null) return 0;
    Duration diff = endAt!.difference(DateTime.now());
    return diff.isNegative ? 0 : diff.inMinutes;
  }

  int getRemainingMilliseconds() {
    if (endAt == null) return 0;
    Duration diff = endAt!.difference(DateTime.now());
    return diff.isNegative ? 0 : diff.inMilliseconds;
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
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      endAt:
          json['endAt'] != null ? (json['endAt'] as Timestamp).toDate() : null,
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
