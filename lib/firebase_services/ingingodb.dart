import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tegura/models/ingingo.dart';

class IngingoService {
  // COLLECTIONS REFERENCE - FIRESTORE
  final CollectionReference ingingoCollection =
      FirebaseFirestore.instance.collection('ingingo');

  // CONSTRUCTOR
  IngingoService();

// #############################################################################
// MODELING DATA
// #############################################################################
  // GET ingingos FROM A SNAPSHOT USING THE INGINGO MODEL - _ingingosFromSnapshot
  // FUNCTION CALLED EVERY TIME THE ingingos DATA CHANGES
  List<IngingoModel> _ingingosFromSnapshot(QuerySnapshot querySnapshot) {
    // GET THE DATA FROM THE SNAPSHOT
    return querySnapshot.docs.map((doc) {
      // GET THE DATA FROM THE SNAPSHOT
      final data = doc.data() as Map<String, dynamic>;

      // CHECK IF THE FIELDS EXISTS BEFORE ASSIGNING TO THE VARIABLE
      final id = data.containsKey('id') ? data['id'] : '';
      final isomoId = data.containsKey('isomoId') ? data['isomoId'] : '';
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
        // INGINGOS DATA
        id: id is int ? id : id is String ? int.parse(id) : 0,
        isomoId: isomoId,
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

  // GET ONE ingingo FROM A SNAPSHOT USING THE INGINGO MODEL - _ingingoFromSnapshot
  // FUNCTION CALLED EVERY TIME THE ingingos DATA CHANGES
  IngingoModel _ingingoFromSnapshot(DocumentSnapshot documentSnapshot) {
    // GET THE DATA FROM THE SNAPSHOT
    final data = documentSnapshot.data() as Map<String, dynamic>;

    // CHECK IF THE FIELDS EXIST BEFORE ASSIGNING TO THE VARIABLE
    final id = data.containsKey('id') ? data['id'] : '';
    final isomoId = data.containsKey('isomoId') ? data['isomoId'] : '';
    final title = data.containsKey('title') ? data['title'] : '';
    final text = data.containsKey('text') ? data['text'] : '';
    final imageUrl = data.containsKey('imageUrl') ? data['imageUrl'] : '';
    final imageTitle = data.containsKey('imageTitle') ? data['imageTitle'] : '';
    final imageDesc = data.containsKey('imageDesc') ? data['imageDesc'] : '';
    final options = data.containsKey('options') ? data['options'] : '';
    final nb = data.containsKey('nb') ? data['nb'] : '';
    final insideTitle =
        data.containsKey('insideTitle') ? data['insideTitle'] : '';

    // RETURN A LIST OF ingingos FROM THE SNAPSHOT
    return IngingoModel(
      // INGINGOS DATA
      id: id is int ? id : id is String ? int.parse(id) : 0,
      isomoId: isomoId,
      title: title,
      text: text,
      imageUrl: imageUrl,
      imageTitle: imageTitle,
      imageDesc: imageDesc,
      options: options,
      nb: nb,
      insideTitle: insideTitle,
    );
  }

// #############################################################################
// GET DATA
// #############################################################################
  // GET ALL ingingos
  Stream<List<IngingoModel>> get ingingos {
    return ingingoCollection.snapshots().map(_ingingosFromSnapshot);
  }

  // GET ONE ingingo
  Stream<IngingoModel> getIngingo(String id) {
    return ingingoCollection.doc(id).snapshots().map(_ingingoFromSnapshot);
  }

// GET TOTAL ingingos FOR A GIVEN isomoId
  Stream<IngingoSum> getTotalIsomoIngingos(int isomoId) {
    // Retrieve the stream of documents from Firestore
    final documentsStream =
        ingingoCollection.where('isomoID', isEqualTo: isomoId).snapshots();

    // Map the stream to the length of the documents and return it
    return documentsStream.map((event) => event.docs.isNotEmpty
        ? IngingoSum(sum: event.docs.length)
        : IngingoSum(sum: 0));
  }

// GET A LIST OF ingingos FOR A GIVEN isomoId, ORDERED BY ITS DOCUMENT ID
  Stream<List<IngingoModel>> getIngingosByIsomoId(String isomoId) {
    // Retrieve the stream of documents from Firestore
    final documentsStream =
        ingingoCollection.where('isomoID', isEqualTo: isomoId).snapshots();

    // Map the stream to a list of ingingos
    return documentsStream.map((event) => _ingingosFromSnapshot(event));
  }

// GET A LIST OF ingingos FOR A GIVEN isomoId, LIMITED TO THE GIVEN NUMBER, AND SKIP THE GIVEN NUMBER OF DOCUMENTS RETURNED FROM THE QUERY RESULTS - PAGINATION - ORDERED BY ITS DOCUMENT ID
  Stream<List<IngingoModel>> getIngingosByIsomoIdPaginated(
      int isomoId, int limit, int lastIDinsideDoc) {
    // Construct the initial query
    Query query = ingingoCollection
        .where('isomoID', isEqualTo: isomoId)
        // Order the documents by the document ID
        .orderBy('id', descending: false)
        .limit(limit);

    // If there is a lastIDinsideDoc, start the query after it
    query = query.startAfter([lastIDinsideDoc]);

    // Retrieve the stream of documents from Firestore
    final documentsStream = query.snapshots();

    // Map the stream to a list of IngingoModel objects
    return documentsStream.map((event) => _ingingosFromSnapshot(event));
  }

// #############################################################################
// CREATE DATA
// #############################################################################
  // CREATE ONE ingingo
  Future createIngingo(IngingoModel ingingo) async {
    return await ingingoCollection.doc(ingingo.id as String?).set({
      'id': ingingo.id,
      'isomoId': ingingo.isomoId,
      'title': ingingo.title,
      'text': ingingo.text,
      'imageUrl': ingingo.imageUrl,
      'imageTitle': ingingo.imageTitle,
      'imageDesc': ingingo.imageDesc,
      'options': ingingo.options,
      'nb': ingingo.nb,
      'insideTitle': ingingo.insideTitle,
    });
  }

// #############################################################################
// UPDATE DATA
// #############################################################################
  // UPDATE ONE ingingo
  Future updateIngingo(IngingoModel ingingo) async {
    return await ingingoCollection.doc(ingingo.id as String?).update({
      'id': ingingo.id,
      'isomoId': ingingo.isomoId,
      'title': ingingo.title,
      'text': ingingo.text,
      'imageUrl': ingingo.imageUrl,
      'imageTitle': ingingo.imageTitle,
      'imageDesc': ingingo.imageDesc,
      'options': ingingo.options,
      'nb': ingingo.nb,
      'insideTitle': ingingo.insideTitle,
    });
  }

// #############################################################################
// DELETE DATA
// #############################################################################
  // DELETE ONE ingingo
  Future deleteIngingo(String id) async {
    return await ingingoCollection.doc(id).delete();
  }
}

// #############################################################################
// END OF FILE
// #############################################################################
