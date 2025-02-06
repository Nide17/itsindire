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
      final data = doc.data() as Map<String, dynamic>? ?? {};

      final igihe = data['igihe'] ?? '';
      final igiciro = data['igiciro'] ?? 0;

      // Convert raw data for questions into List<ifatabuguziQuestion>
      final ibirimoData = data['ibirimo'] ?? [];
      final ibirimo = List<String>.from(ibirimoData);
      final ubusobanuro =
          data['ubusobanuro'] ?? '';
      final type = data['type'] ?? '';

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

  Future<DocumentSnapshot> getIfatabuguziById(String? ifatabuguziID) async {
    try {
      return await ifatabuguziCollection.doc(ifatabuguziID).get();
    } catch (e) {
      print('Error getting document: $e');
      rethrow;
    }
  }
}
