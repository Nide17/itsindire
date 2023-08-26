import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tegura/models/isuzuma.dart';

class IsuzumaService {
  // COLLECTIONS REFERENCE - FIRESTORE
  final CollectionReference isuzumaCollection =
      FirebaseFirestore.instance.collection('amasuzumabumenyi');

  // CONSTRUCTOR
  IsuzumaService();

// #############################################################################
// MODELING DATA
// #############################################################################
  // GET AMASUZUMA FROM A SNAPSHOT USING THE Isuzuma MODEL - _amasuzumaFromSnapshot
  List<IsuzumaModel> _amasuzumaFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final id = doc.id;
      final title = data.containsKey('title') ? data['title'] : '';
      final description =
          data.containsKey('description') ? data['description'] : '';

      // Convert raw data for questions into List<IsuzumaQuestion>
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

  // GET ONE isuzuma FROM A SNAPSHOT USING THE isuzuma MODEL - _isuzumaFromSnapshot
  // FUNCTION CALLED EVERY TIME THE AMASUZUMA DATA CHANGES
  IsuzumaModel _isuzumaFromSnapshot(DocumentSnapshot documentSnapshot) {
    // GET THE DATA FROM THE SNAPSHOT
    final data = documentSnapshot.data() as Map<String, dynamic>;

    // CHECK IF THE FIELDS EXIST BEFORE ASSIGNING TO THE VARIABLE
    final id = documentSnapshot.id;
    final title = data.containsKey('title') ? data['title'] : '';
    final description =
        data.containsKey('description') ? data['description'] : '';
    final questions = data.containsKey('questions') ? data['questions'] : '';

    // RETURN A LIST OF AMASUZUMA FROM THE SNAPSHOT
    return IsuzumaModel(
      id: id,
      title: title,
      description: description,
      questions: questions,
    );
  }

// #############################################################################
// GET DATA
// #############################################################################
  // GET ALL AMASUZUMA
  Stream<List<IsuzumaModel>> get amasuzumabumenyi {
    // // PRINT THE DATA _amasuzumaFromSnapshot TO THE CONSOLE
    // isuzumaCollection.snapshots().listen((event) {
    //   print(_amasuzumaFromSnapshot(event));
    // });

    return isuzumaCollection.snapshots().map(_amasuzumaFromSnapshot);
  }

  // GET ONE isuzuma
  Stream<IsuzumaModel> getIsuzuma(String id) {
    return isuzumaCollection.doc(id).snapshots().map(_isuzumaFromSnapshot);
  }
}
// #############################################################################
// END OF FILE
// #############################################################################
