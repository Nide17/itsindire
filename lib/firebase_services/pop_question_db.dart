import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itsindire/models/pop_question.dart';

class PopQuestionService {
  final CollectionReference popQuestionCollection =
      FirebaseFirestore.instance.collection('pop_questions');

  PopQuestionService();

// GET POP QUESTIONS FROM A SNAPSHOT USING THE pop_question MODEL - _popQuestionsFromSnapshot
  // FUNCTION CALLED EVERY TIME THE POP QUESTIONS DATA CHANGES
  List<PopQuestionModel> _popQuestionsFromSnapshot(
      QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;

      // CHECK IF THE FIELDS EXISTS BEFORE ASSIGNING TO THE VARIABLE
      final ingingoID = data.containsKey('ingingoID') ? data['ingingoID'] : 0;
      final isomoID = data.containsKey('isomoID') ? data['isomoID'] : 0;
      final title = data.containsKey('title') ? data['title'] : '';
      final imageUrl = data.containsKey('imageUrl') ? data['imageUrl'] : '';
      final optionsData = data.containsKey('options') ? data['options'] : [];

      final options = List<OptionPopQn>.from(
          optionsData.map((optionData) => OptionPopQn.fromJson(optionData)));

      // RETURN A LIST OF POP QUESTIONS FROM THE SNAPSHOT
      return PopQuestionModel(
        id: id,
        ingingoID: ingingoID,
        isomoID: isomoID,
        title: title,
        imageUrl: imageUrl,
        options: options,
      );
    }).toList();
  }

// GET A LIST OF pop questions FOR A LIST OF ingingoID, ORDERED BY ITS DOCUMENT ID
  Stream<List<PopQuestionModel>> getPopQuestionsByIngingoIDs(
      int isomoID, List<int> ingingoIDs) {
    if (ingingoIDs.isEmpty) {
      return const Stream.empty();
    }
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
    final documentsStream =
        popQuestionCollection.where('isomoID', isEqualTo: isomoID).snapshots();
    return documentsStream.map((event) => _popQuestionsFromSnapshot(event));
  }
}
