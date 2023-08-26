import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tegura/models/payment.dart';

class PaymentService {
  // COLLECTIONS REFERENCE - FIRESTORE
  final CollectionReference paymentsCollection =
      FirebaseFirestore.instance.collection('payments');

  // CONSTRUCTOR
  PaymentService();

// #############################################################################
// MODELING DATA
// #############################################################################
  // GET amafatabuguzi FROM A SNAPSHOT USING THE ifatabuguzi MODEL - _paymentsFromSnapshot
  List<PaymentModel> _paymentsFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final id = doc.id;
      final createdAt = data.containsKey('createdAt')
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now();
      final endAt = data.containsKey('endAt')
          ? (data['endAt'] as Timestamp).toDate()
          : DateTime.now();
      final userId = data.containsKey('userId') ? data['userId'] : '';
      final ifatabuguziID =
          data.containsKey('ifatabuguziID') ? data['ifatabuguziID'] : '';
      final isApproved =
          data.containsKey('isApproved') ? data['isApproved'] : false;
          final phone = data.containsKey('phone') ? data['phone'] : '';

      return PaymentModel(
        id: id,
        createdAt: createdAt,
        endAt: endAt,
        userId: userId,
        ifatabuguziID: ifatabuguziID,
        isApproved: isApproved,
        phone: phone,
      );
    }).toList();
  }

  // GET ONE ifatabuguzi FROM A SNAPSHOT USING THE ifatabuguzi MODEL - _paymentFromSnapshot
  // FUNCTION CALLED EVERY TIME THE amafatabuguzi DATA CHANGES
  PaymentModel _paymentFromSnapshot(DocumentSnapshot documentSnapshot) {
    // GET THE DATA FROM THE SNAPSHOT
    final data = documentSnapshot.data() as Map<String, dynamic>;

    // CHECK IF THE FIELDS EXIST BEFORE ASSIGNING TO THE VARIABLE
    final id = documentSnapshot.id;
    final createdAt = data.containsKey('createdAt')
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now();
    final endAt = data.containsKey('endAt')
        ? (data['endAt'] as Timestamp).toDate()
        : DateTime.now();
    final userId = data.containsKey('userId') ? data['userId'] : '';
    final ifatabuguziID =
        data.containsKey('ifatabuguziID') ? data['ifatabuguziID'] : '';
    final isApproved =
        data.containsKey('isApproved') ? data['isApproved'] : false;
    final phone = data.containsKey('phone') ? data['phone'] : '';
    // RETURN A LIST OF amafatabuguzi FROM THE SNAPSHOT
    return PaymentModel(
      id: id,
      createdAt: createdAt,
      endAt: endAt,
      userId: userId,
      ifatabuguziID: ifatabuguziID,
      isApproved: isApproved,
      phone: phone,
    );
  }

// #############################################################################
// GET DATA
// #############################################################################
  // GET ALL amafatabuguzi
  Stream<List<PaymentModel>> getPayments() {
    // PRINT THE DATA _paymentsFromSnapshot TO THE CONSOLE
    paymentsCollection.snapshots().listen((event) {
      print(_paymentsFromSnapshot(event));
    });

    return paymentsCollection.snapshots().map(_paymentsFromSnapshot);
  }

  // GET ONE PAYMENT
  Stream<PaymentModel> getPayment(String id) {
    return paymentsCollection.doc(id).snapshots().map(_paymentFromSnapshot);
  }

  // GET USER PAYMNENTS BY USER ID
  Stream<List<PaymentModel>> getpaymentsByUserId(String userId) {
    return paymentsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(_paymentsFromSnapshot);
  }

  // GET USER LATEST PAYMENT BY USER ID
  Stream<PaymentModel?> getLatestpaymentsByUserId(String userId) {
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
  Future<dynamic> getUserLatestPaymentData(String uid) async {
    // GET THE USER LATEST PAYMENT DATA
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
  Future<bool> createPayment(PaymentModel payment) async {
    try {
      await paymentsCollection.add(payment.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
// #############################################################################
// END OF FILE
// #############################################################################
