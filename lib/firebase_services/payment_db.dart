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
      final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
      final endAt = (data['endAt'] as Timestamp?)?.toDate();
      final userId = data['userId'] ?? '';
      final ifatabuguziID = data['ifatabuguziID'] ?? '';
      final igiciro = data['igiciro'] ?? 0;
      final isApproved = data['isApproved'] ?? false;
      final phone = data['phone'] ?? '';

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

  Stream<PaymentModel?> getNewestPytByUserId(String userId) {
    print('User ID: $userId');
    return paymentsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        print('No payment found');
        return null;
      } else {
        print('Payment found');
        return _paymentFromSnapshot(snapshot.docs.first);
      }
    });
  }

  Future<dynamic> getUserLatestPytData(String uid) async {
    final snapshot = await paymentsCollection
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      print('No payment found');
      return null;
    } else {
      print('Payment found');
      return _paymentFromSnapshot(snapshot.docs.first);
    }
  }

  Future<ReturnedResult> createPayment(PaymentModel payment) async {
    try {
      final activePaymentError = await _checkActivePayments(payment.userId!);
      if (activePaymentError != null) {
        return ReturnedResult(error: activePaymentError);
      }

      if (payment.userId != null) {
        await _deleteSpecificPayments(payment.userId!, 'UGl3ahnKZdVrBVTItht7');
      } else {
        throw Exception('User ID is null');
      }

      await paymentsCollection.doc(payment.userId).set(payment.toJson());

      await _sendPaymentNotification(payment);

      return ReturnedResult(value: true);
    } catch (e) {
      print('Error: $e');
      return ReturnedResult(error: 'Failed to create payment: $e');
    }
  }

  Future<String?> _checkActivePayments(String userId) async {
    final activePayment = await paymentsCollection
        .where('userId', isEqualTo: userId)
        .where('endAt', isGreaterThan: DateTime.now())
        .get();

    if (activePayment.docs.isNotEmpty) {
      for (var doc in activePayment.docs) {
        if (doc.get('isApproved') &&
            doc.get('ifatabuguziID') != 'UGl3ahnKZdVrBVTItht7') {
          return 'Ufite ifatabuguzi ritararangira, reka rirangire cga utuvugishe turihindure!';
        }
      }
    }
    return null;
  }

  Future<void> _deleteSpecificPayments(String userId, String ifatabuguziID) async {
    final specificPayments = await paymentsCollection
        .where('userId', isEqualTo: userId)
        .where('ifatabuguziID', isEqualTo: ifatabuguziID)
        .get();

    for (var doc in specificPayments.docs) {
      await paymentsCollection.doc(doc.id).delete();
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
