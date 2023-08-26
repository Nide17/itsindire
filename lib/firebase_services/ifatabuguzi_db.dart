import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tegura/models/ifatabuguzi.dart';

class IfatabuguziService {
  // COLLECTIONS REFERENCE - FIRESTORE
  final CollectionReference ifatabuguziCollection =
      FirebaseFirestore.instance.collection('amafatabuguzi');

  // CONSTRUCTOR
  IfatabuguziService();

// #############################################################################
// MODELING DATA
// #############################################################################
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

  // GET ONE ifatabuguzi FROM A SNAPSHOT USING THE ifatabuguzi MODEL - _ifatabuguziFromSnapshot
  // FUNCTION CALLED EVERY TIME THE amafatabuguzi DATA CHANGES
  IfatabuguziModel _ifatabuguziFromSnapshot(DocumentSnapshot documentSnapshot) {
    // GET THE DATA FROM THE SNAPSHOT
    final data = documentSnapshot.data() as Map<String, dynamic>;

    // CHECK IF THE FIELDS EXIST BEFORE ASSIGNING TO THE VARIABLE
    final id = documentSnapshot.id;
    final igihe = data.containsKey('igihe') ? data['igihe'] : '';
    final igiciro = data.containsKey('igiciro') ? data['igiciro'] : 0;

    // Convert raw data for questions into List<ifatabuguziQuestion>
    final ibirimoData = data.containsKey('ibirimo') ? data['ibirimo'] : [];
    final ibirimo = List<String>.from(ibirimoData);
    final ubusobanuro =
        data.containsKey('ubusobanuro') ? data['ubusobanuro'] : '';
    final type = data.containsKey('type') ? data['type'] : '';

    // RETURN A LIST OF amafatabuguzi FROM THE SNAPSHOT
    return IfatabuguziModel(
      id: id,
      igihe: igihe,
      igiciro: igiciro,
      ibirimo: ibirimo,
      ubusobanuro: ubusobanuro,
      type: type,
    );
  }

// #############################################################################
// GET DATA
// #############################################################################
  // GET ALL amafatabuguzi
  Stream<List<IfatabuguziModel>> get amafatabuguzi {
    return ifatabuguziCollection.snapshots().map(_amafatabuguziFromSnapshot);
  }

  // GET ONE ifatabuguzi
  Stream<IfatabuguziModel> getIfatabuguzi(String id) {
    return ifatabuguziCollection
        .doc(id)
        .snapshots()
        .map(_ifatabuguziFromSnapshot);
  }
}
// #############################################################################
// END OF FILE
// #############################################################################
