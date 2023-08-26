import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tegura/models/pop_question.dart';

class PopQuestionService {
  // COLLECTIONS REFERENCE - FIRESTORE
  final CollectionReference popQuestionCollection =
      FirebaseFirestore.instance.collection('pop_questions');

  // CONSTRUCTOR
  PopQuestionService();

// #############################################################################
// MODELING DATA
// #############################################################################
  // GET POP QUESTIONS FROM A SNAPSHOT USING THE pop_question MODEL - _popQuestionsFromSnapshot
  // FUNCTION CALLED EVERY TIME THE POP QUESTIONS DATA CHANGES
  List<PopQuestionModel> _popQuestionsFromSnapshot(
      QuerySnapshot querySnapshot) {
    // GET THE DATA FROM THE SNAPSHOT
    return querySnapshot.docs.map((doc) {
      // GET THE DATA FROM THE SNAPSHOT
      final data = doc.data() as Map<String, dynamic>;

      // document id - pop_question id
      final id = doc.id;

      // CHECK IF THE FIELDS EXISTS BEFORE ASSIGNING TO THE VARIABLE
      final ingingoID = data.containsKey('ingingoID') ? data['ingingoID'] : '';
      final isomoID = data.containsKey('isomoID') ? data['isomoID'] : '';
      final title = data.containsKey('title') ? data['title'] : '';
      final options = data.containsKey('options') ? data['options'] : '';

      // RETURN A LIST OF POP QUESTIONS FROM THE SNAPSHOT
      return PopQuestionModel(
        // POP QUESTIONS DATA
        id: id,
        ingingoID: ingingoID,
        isomoID: isomoID,
        title: title,
        options: options,
      );
    }).toList();
  }

  // GET ONE pop_question FROM A SNAPSHOT USING THE pop_question MODEL - _popQuestionFromSnapshot
  // FUNCTION CALLED EVERY TIME THE POP QUESTIONS DATA CHANGES
  PopQuestionModel _popQuestionFromSnapshot(DocumentSnapshot documentSnapshot) {
    // GET THE DATA FROM THE SNAPSHOT
    final data = documentSnapshot.data() as Map<String, dynamic>;

    // CHECK IF THE FIELDS EXIST BEFORE ASSIGNING TO THE VARIABLE
    final id = documentSnapshot.id;
    final ingingoID = data.containsKey('ingingoID') ? data['ingingoID'] : '';
    final isomoID = data.containsKey('isomoID') ? data['isomoID'] : '';
    final title = data.containsKey('title') ? data['title'] : '';
    final options = data.containsKey('options') ? data['options'] : '';

    // RETURN A LIST OF POP QUESTIONS FROM THE SNAPSHOT
    return PopQuestionModel(
      // POP QUESTIONS DATA
      id: id,
      ingingoID: ingingoID,
      isomoID: isomoID,
      title: title,
      options: options,
    );
  }

// #############################################################################
// GET DATA
// #############################################################################
  // GET ALL pop questions
  Stream<List<PopQuestionModel>> get popQuestions {
    return popQuestionCollection.snapshots().map(_popQuestionsFromSnapshot);
  }

  // GET ONE pop_question
  Stream<PopQuestionModel> getPopQuestion(String id) {
    return popQuestionCollection
        .doc(id)
        .snapshots()
        .map(_popQuestionFromSnapshot);
  }

// GET A LIST OF pop questions FOR A GIVEN ingingoID, ORDERED BY ITS DOCUMENT ID
  Stream<List<PopQuestionModel>> getPopQuestionsByIngingoID(String ingingoID) {
    // Retrieve the stream of documents from Firestore
    final documentsStream = popQuestionCollection
        .where('ingingoID', isEqualTo: ingingoID)
        .snapshots();

    // Map the stream to a list of pop questions
    return documentsStream.map((event) => _popQuestionsFromSnapshot(event));
  }

// GET A LIST OF pop questions FOR A LIST OF ingingoID, ORDERED BY ITS DOCUMENT ID
  Stream<List<PopQuestionModel>> getPopQuestionsByIngingoIDs(
      int isomoID, List<int> ingingoIDs) {
    print('getPopQuestionsByIngingoIDs: $isomoID, $ingingoIDs');
    // IF THE LIST IS EMPTY, RETURN AN EMPTY STREAM
    if (ingingoIDs.isEmpty) {
      return const Stream.empty();
    }

    // Retrieve the stream of documents from Firestore
    final documentsStream = popQuestionCollection
        .where(
          'isomoID',
          isEqualTo: isomoID,
        )
        .where('ingingoID', whereIn: ingingoIDs)
        .snapshots();

    // Map the stream to a list of pop questions
    return documentsStream.map((event) => _popQuestionsFromSnapshot(event));
  }

// GET A LIST OF pop questions FOR A GIVEN isomoID, ORDERED BY ITS DOCUMENT ID
  Stream<List<PopQuestionModel>> getPopQuestionsByIsomoID(int isomoID) {
    // Retrieve the stream of documents from Firestore
    final documentsStream =
        popQuestionCollection.where('isomoID', isEqualTo: isomoID).snapshots();

    // Map the stream to a list of pop questions
    return documentsStream.map((event) => _popQuestionsFromSnapshot(event));
  }

// #############################################################################
// CREATE DATA
// #############################################################################
  // CREATE ONE pop_question
  Future createPopQuestion(PopQuestionModel popQn) async {
    return await popQuestionCollection.doc().set({
      'ingingoID': popQn.ingingoID,
      'isomoID': popQn.isomoID,
      'title': popQn.title,
      'options': popQn.options,
    });
  }

// #############################################################################
// UPDATE DATA
// #############################################################################
  // UPDATE ONE pop_question
  Future updatePopQuestion(PopQuestionModel popQn, String id) async {
    return await popQuestionCollection.doc(id).update({
      'ingingoID': popQn.ingingoID,
      'isomoID': popQn.isomoID,
      'title': popQn.title,
      'options': popQn.options,
    });
  }

// #############################################################################
// DELETE DATA
// #############################################################################
  // DELETE ONE pop_question
  Future deletePopQuestion(String id) async {
    return await popQuestionCollection.doc(id).delete();
  }
}

// #############################################################################
// END OF FILE
// #############################################################################
