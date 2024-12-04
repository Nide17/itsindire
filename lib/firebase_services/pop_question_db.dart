import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itsindire/models/pop_question.dart';

class PopQuestionService {
  final CollectionReference popQuestionCollection =
      FirebaseFirestore.instance.collection('pop_questions');

  PopQuestionService();

  List<PopQuestionModel> _popQuestionsFromSnapshot(
      QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;

      final ingingoID = data.containsKey('ingingoID') ? data['ingingoID'] : 0;
      final isomoID = data.containsKey('isomoID') ? data['isomoID'] : 0;
      final title = data.containsKey('title') ? data['title'] : '';
      final imageUrl = data.containsKey('imageUrl') ? data['imageUrl'] : '';
      final optionsData = data.containsKey('options') ? data['options'] : [];

      final options = List<OptionPopQn>.from(
          optionsData.map((optionData) => OptionPopQn.fromJson(optionData)));

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

    return documentsStream.map((event) => _popQuestionsFromSnapshot(event));
  }

  Stream<List<PopQuestionModel>> getPopQuestionsByIsomoID(int isomoID) {
    final documentsStream =
        popQuestionCollection.where('isomoID', isEqualTo: isomoID).snapshots();
    return documentsStream.map((event) => _popQuestionsFromSnapshot(event));
  }
}
