import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tegura/models/ibibazo_bibaza.dart';

class IbibazoBibazaService {
  // COLLECTIONS REFERENCE - FIRESTORE
  final CollectionReference ibibazoBibazaCollection =
      FirebaseFirestore.instance.collection('ibibazo_bibaza');

  IbibazoBibazaService();

// #############################################################################
// MODELING DATA
// #############################################################################
  // GET ibibazoBibaza FROM A SNAPSHOT USING THE ibibazoBibaza MODEL - _ibibazoBibazaFromSnapshot
  List<IbibazoBibazaModel> _ibibazoBibazaFromSnapshot(
      QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final question = data.containsKey('question') ? data['question'] : '';
      final answer = data.containsKey('answer') ? data['answer'] : '';

      return IbibazoBibazaModel(
        id: doc.id,
        question: question,
        answer: answer,
      );
    }).toList();
  }

// #############################################################################
// GET DATA
// #############################################################################
  // GET ALL ibibazoBibaza
  Stream<List<IbibazoBibazaModel>> get ibibazoBibaza {
    return ibibazoBibazaCollection.snapshots().map(_ibibazoBibazaFromSnapshot);
  }
}
