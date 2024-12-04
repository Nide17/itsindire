import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itsindire/models/ibibazo_bibaza.dart';

class IbibazoBibazaService {
  final CollectionReference ibibazoBibazaCollection =
      FirebaseFirestore.instance.collection('ibibazo_bibaza');

  IbibazoBibazaService();

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
  
  Stream<List<IbibazoBibazaModel>> get ibibazoBibaza {
    return ibibazoBibazaCollection.snapshots().map(_ibibazoBibazaFromSnapshot).handleError((error) {
      print('Error fetching data: $error');
      return [];
    });
  }
}
