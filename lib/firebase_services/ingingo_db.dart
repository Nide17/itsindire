import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itsindire/models/ingingo.dart';

class IngingoService {
  // COLLECTIONS REFERENCE - FIRESTORE
  final CollectionReference ingingoCollection =
      FirebaseFirestore.instance.collection('ingingo');

  IngingoService();

  // GET ingingos FROM A SNAPSHOT USING THE INGINGO MODEL - _ingingosFromSnapshot
  List<IngingoModel> _ingingosFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = data.containsKey('id') ? data['id'] : 0;
      final isomoID = data.containsKey('isomoID') ? data['isomoID'] : 0;
      final title = data.containsKey('title') ? data['title'] : '';
      final text = data.containsKey('text') ? data['text'] : '';
      final imageUrl = data.containsKey('imageUrl') ? data['imageUrl'] : '';
      final imageTitle =
          data.containsKey('imageTitle') ? data['imageTitle'] : '';
      final imageDesc = data.containsKey('imageDesc') ? data['imageDesc'] : '';
      final options = data.containsKey('options') ? data['options'] : '';
      final nb = data.containsKey('nb') ? data['nb'] : '';
      final insideTitle =
          data.containsKey('insideTitle') ? data['insideTitle'] : '';

      // RETURN A LIST OF ingingos FROM THE SNAPSHOT
      return IngingoModel(
        id: id,
        isomoID: isomoID,
        title: title,
        text: text,
        imageUrl: imageUrl,
        imageTitle: imageTitle,
        imageDesc: imageDesc,
        options: options,
        nb: nb,
        insideTitle: insideTitle,
      );
    }).toList();
  }

// GET TOTAL ingingos FOR A GIVEN isomoID
  Stream<IsomoIngingoSum> getTotalIsomoIngingos(int isomoID) {
    final documentsStream =
        ingingoCollection.where('isomoID', isEqualTo: isomoID).snapshots();

    // // print them
    // documentsStream.listen((event) {
    //   print('Total ingingos: ${event.docs.length}');
    // });
    return documentsStream
        .map((event) => IsomoIngingoSum(realTotalIngingos: event.docs.length));
  }

// GET ingingos FOR A GIVEN isomoID, ORDERED BY ITS DOCUMENT ID
  Stream<List<IngingoModel>> getIngingosByIsomoIdPaginated(
      int isomoID, int limit, int lastIDinsideDoc) {
    return ingingoCollection
        .where('isomoID', isEqualTo: isomoID)
        .orderBy('id')
        .startAfter([lastIDinsideDoc])
        .limit(limit)
        .snapshots()
        .map(_ingingosFromSnapshot);
  }
}

class IsomoIngingoSum {
  final int realTotalIngingos;
  IsomoIngingoSum({required this.realTotalIngingos});

  // GETTER AND SETTER
  int get totalIngingos => realTotalIngingos;

  @override
  String toString() {
    return 'IsomoIngingoSum{realTotalIngingos: $realTotalIngingos}';
  }
}
