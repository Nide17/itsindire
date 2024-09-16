import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tegura/models/isuzuma.dart';

class IsuzumaService {
  final CollectionReference isuzumaCollection =
      FirebaseFirestore.instance.collection('amasuzumabumenyi');

  IsuzumaService();

  // GET AMASUZUMA FROM A SNAPSHOT USING THE Isuzuma MODEL - _amasuzumaFromSnapshot
  List<IsuzumaModel> _amasuzumaFromSnapshot(QuerySnapshot querySnapshot) {

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final id = doc.id;
      final title = data.containsKey('title') ? data['title'] : '';
      final description =
          data.containsKey('description') ? data['description'] : '';

      final questionsData =
          data.containsKey('questions') ? data['questions'] : [];
      final questions = List<IsuzumaQuestion>.from(
          questionsData.map((qnData) => IsuzumaQuestion.fromJson(qnData)));

      return IsuzumaModel(
        id: id,
        title: title,
        description: description,
        questions: questions,
      );
    }).toList();
  }

  IsuzumaModel _isuzumaFromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;

    // CHECK IF THE FIELDS EXIST BEFORE ASSIGNING TO THE VARIABLE
    final id = documentSnapshot.id;
    final String title = data.containsKey('title') ? data['title'] : '';
    final String description =
        data.containsKey('description') ? data['description'] : '';
    final questionsData =
        data.containsKey('questions') ? data['questions'] : [];
    final questions = List<IsuzumaQuestion>.from(
        questionsData.map((qnData) => IsuzumaQuestion.fromJson(qnData)));

    // RETURN A LIST OF amafatabuguzi FROM THE SNAPSHOT
    return IsuzumaModel(
      id: id,
      title: title,
      description: description,
      questions: questions,
    );
  }

  // GET ALL AMASUZUMA
  Stream<List<IsuzumaModel>> get amasuzumabumenyi {
    return isuzumaCollection.snapshots().map(_amasuzumaFromSnapshot);
  }

  Stream<IsuzumaModel?> getIsuzumaByTitle(String title) {
    final documentsStream =
        isuzumaCollection.where('title', isEqualTo: title).limit(1).snapshots();

    return documentsStream.map((querySnapshot) {
      final documents = querySnapshot.docs;

      if (documents.isEmpty) {
        return null;
      } else {
        return _isuzumaFromSnapshot(documents.first);
      }
    });
  }
}