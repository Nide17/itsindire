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

  PaymentModel? _paymentFromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;

    try {
      final createdAt = data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null;
      final endAt = data['endAt'] != null
          ? (data['endAt'] as Timestamp).toDate()
          : null;
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
    } catch (e) {
      print('\n\n\nError: $e\n\n');
      return null;
    }
  }

// GET DATA
// #############################################################################
  // GET USER LATEST PAYMENT BY USER ID
  Stream<PaymentModel?> getNewestPytByUserId(String userId) {
    return paymentsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      } else {
        return _paymentFromSnapshot(snapshot.docs.first);
      }
    });
  }

  // GET PAYMENT DATA
  Future<dynamic> getUserLatestPytData(String uid) async {
    final snapshot = await paymentsCollection
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    } else {
      return _paymentFromSnapshot(snapshot.docs.first);
    }
  }

  // CREATE PAYMENT
  Future<ReturnedResult> createPayment(PaymentModel payment) async {
    try {
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
              error:
                  'You have an active payment. Please wait for it to end, or contact us for change!',
            );
          }
        }
      }

      // CREATE PAYMENT IN FIRESTORE AND SET THE ID AS THE PHONE NUMBER
      await paymentsCollection.doc(payment.userId).set(payment.toJson());

      // SEND EMAIL NOTIFICATION
      await _sendPaymentNotification(payment);

      return ReturnedResult(value: true);
    } catch (e) {
      print('Error: $e');
      return ReturnedResult(error: 'Failed to create payment: $e');
    }
  }

  // SEND EMAIL NOTIFICATION
  Future<void> _sendPaymentNotification(PaymentModel payment) async {
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
      print('Error sending email: $e');
    }
  }
}
