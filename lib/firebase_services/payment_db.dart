import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itsindire/main.dart';
import 'package:itsindire/models/payment.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentService {
  PaymentService();

  final CollectionReference paymentsCollection =
      FirebaseFirestore.instance.collection('payments');

  // GET ONE PAYMENT FROM A SNAPSHOT USING THE PAYMENT MODEL - _paymentFromSnapshot
  // FUNCTION RUN EVERY TIME THE A PAYMENT INFO CHANGES
  PaymentModel _paymentFromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;

    final createdAt = data.containsKey('createdAt')
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now();
    final endAt = data.containsKey('endAt')
        ? (data['endAt'] as Timestamp).toDate()
        : DateTime.now();
    final userId = data.containsKey('userId') ? data['userId'] : '';
    final ifatabuguziID =
        data.containsKey('ifatabuguziID') ? data['ifatabuguziID'] : '';
    final igiciro = data.containsKey('igiciro') ? data['igiciro'] : 0;
    final isApproved =
        data.containsKey('isApproved') ? data['isApproved'] : false;
    final phone = data.containsKey('phone') ? data['phone'] : '';

    return PaymentModel(
      createdAt: createdAt,
      endAt: endAt,
      userId: userId,
      ifatabuguziID: ifatabuguziID,
      igiciro: igiciro,
      isApproved: isApproved,
      phone: phone,
    );
  }

// GET DATA
// #############################################################################
  // GET USER LATEST PAYMENT BY USER ID
  Stream<PaymentModel?> getNewestPytByUserId(String userId) {
    final documentsStream = paymentsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots();

    return documentsStream.map((querySnapshot) {
      final documents = querySnapshot.docs;

      if (documents.isEmpty) {
        return null;
      } else {
        return _paymentFromSnapshot(documents.first);
      }
    });
  }

  // GET PAYMENT DATA
  Future<dynamic> getUserLatestPytData(String uid) async {
    final paymentData = await paymentsCollection
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    // CHECK IF THE PAYMENT DATA IS EMPTY
    if (paymentData.docs.isEmpty) {
      return null;
    } else {
      return _paymentFromSnapshot(paymentData.docs.first);
    }
  }

  // CREATE PAYMENT
  Future<ReturnedResult> createPayment(PaymentModel payment) async {
    // CHECK IF THERE IS AN ACTIVE PAYMENT FOR THE USER
    final activePayment = await paymentsCollection
        .where('userId', isEqualTo: payment.userId)
        .where('endAt', isGreaterThan: DateTime.now())
        .get();

    // IF THE ACTIVE PAYMENT IS NOT EMPTY, RETURN FALSE WITH A MESSAGE
    if (activePayment.docs.isNotEmpty) {
      for (var doc in activePayment.docs) {
        if (doc.get('isApproved')) {
          return ReturnedResult(
            error: 'You have an active payment. Please wait for it to end!',
          );
        }
      }
    }

    // CREATE PAYMENT IN FIRESTORE AND SET THE ID AS THE PHONE NUMBER
    await paymentsCollection.doc(payment.phone).set(payment.toJson());

    String username = dotenv.env['GMAIL_EMAIL']!;
    String password = dotenv.env['GMAIL_PASSWORD']!;

    // CREATE THE SMTP SERVER
    final smtpServer = gmail(username, password);

    // CREATE THE MESSAGE
    final message = Message()
      ..from = Address(username, 'Itsindire')
      ..recipients.add(username)
      ..ccRecipients.addAll(['brucendati@gmail.com'])
      ..subject = 'Itsindire Payment'
      ..html =
          "<h1>Payment</h1>\n<p>Payment ${payment.phone} has been made by user ID: ${payment.userId!}</p>\n<p>Payment Phone: ${payment.phone!}</p>\n<p>Payment amount: ${payment.igiciro!}</p>\n<p>Payment Created At: ${payment.createdAt}</p>\n<p>Payment End At: ${payment.endAt}</p>\n<p>Payment isApproved: ${payment.isApproved}</p>";

    // SEND THE MESSAGE
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on Exception catch (e) {
      print('Error: $e');
      return ReturnedResult(value: true);
    }

    return ReturnedResult(value: true);
  }
}
