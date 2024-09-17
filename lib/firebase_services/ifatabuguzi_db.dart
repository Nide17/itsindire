import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itsindire/models/ifatabuguzi.dart';

class IfatabuguziService {
  final CollectionReference ifatabuguziCollection =
      FirebaseFirestore.instance.collection('amafatabuguzi');

  IfatabuguziService();

  // GET amafatabuguzi FROM A SNAPSHOT USING THE ifatabuguzi MODEL - _amafatabuguziFromSnapshot
  List<IfatabuguziModel> _amafatabuguziFromSnapshot(
      QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final igihe = data.containsKey('igihe') ? data['igihe'] : '';
      final igiciro = data.containsKey('igiciro') ? data['igiciro'] : 0;

      // Convert raw data for questions into List<ifatabuguziQuestion>
      final ibirimoData = data.containsKey('ibirimo') ? data['ibirimo'] : [];
      final ibirimo = List<String>.from(ibirimoData);
      final ubusobanuro =
          data.containsKey('ubusobanuro') ? data['ubusobanuro'] : '';
      final type = data.containsKey('type') ? data['type'] : '';

      return IfatabuguziModel(
        id: doc.id,
        igihe: igihe,
        igiciro: igiciro,
        ibirimo: ibirimo,
        ubusobanuro: ubusobanuro,
        type: type,
      );
    }).toList();
  }

  // GET ALL amafatabuguzi
  Stream<List<IfatabuguziModel>> get amafatabuguzi {
    return ifatabuguziCollection.snapshots().map(_amafatabuguziFromSnapshot);
  }
}
