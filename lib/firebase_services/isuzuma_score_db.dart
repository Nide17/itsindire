import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tegura/models/isuzuma_score.dart';

class IsuzumaScoreService {
  // COLLECTIONS REFERENCE - FIRESTORE
  final CollectionReference isuzumaScoresCollection =
      FirebaseFirestore.instance.collection('scores');

  // CONSTRUCTOR
  IsuzumaScoreService();

// #############################################################################
// MODELING DATA
// #############################################################################
  // GET AMASUZUMA SCORES FROM A SNAPSHOT USING THE Isuzuma MODEL - _amasuzumaScoreFromSnapshot
  List<IsuzumaScoreModel> _amasuzumaScoreFromSnapshot(
      QuerySnapshot querySnapshot) {
    // GET THE DATA FROM THE SNAPSHOT
    return querySnapshot.docs.map((doc) {
      // GET THE DATA FROM THE SNAPSHOT
      final data = doc.data() as Map<String, dynamic>;

      // document id - Isuzuma id
      final id = doc.id;

      // CHECK IF THE FIELDS EXISTS BEFORE ASSIGNING TO THE VARIABLE
      final isuzumaID = data.containsKey('isuzumaID') ? data['isuzumaID'] : '';
      final takerID = data.containsKey('takerID') ? data['takerID'] : '';
      final marks = data.containsKey('marks') ? data['marks'] : 0;
      final totalMarks =
          data.containsKey('totalMarks') ? data['totalMarks'] : 0;
      final dateTaken = data.containsKey('dateTaken')
          ? (data['dateTaken'] as Timestamp).toDate()
          : DateTime.now();
      final isuzumaTitle =
          data.containsKey('isuzumaTitle') ? data['isuzumaTitle'] : '';

      // type 'List<dynamic>' is not a subtype of type 'List<ScoreQuestionI>'
      // CONVERT THE QUESTIONS LIST TO A LIST OF ScoreQuestionI OBJECTS
      final questionsJson = data.containsKey('questions')
          ? data['questions'] as List<dynamic>
          : [];
      final questions = questionsJson
          .map<ScoreQuestionI>(
              (questionJson) => ScoreQuestionI.fromJson(questionJson))
          .toList();

      // CONVERT THE AMASOMO LIST TO A LIST OF STRINGS
      final amasomoJson =
          data.containsKey('amasomo') ? data['amasomo'] as List<dynamic> : [];
      final amasomo =
          amasomoJson.map<String>((amasomo) => amasomo.toString()).toList();

      // RETURN A LIST OF AMASUZUMA SCORES FROM THE SNAPSHOT
      return IsuzumaScoreModel(
        // AMASUZUMA SCORES DATA
        id: id,
        isuzumaID: isuzumaID,
        takerID: takerID,
        marks: marks,
        totalMarks: totalMarks,
        dateTaken: dateTaken,
        questions: questions,
        amasomo: amasomo,
        isuzumaTitle: isuzumaTitle,
      );
    }).toList();
  }

  // GET ONE isuzuma FROM A SNAPSHOT USING THE isuzuma MODEL - _isuzumaScoreFromSnapshot
  // FUNCTION CALLED EVERY TIME THE AMASUZUMA SCORES DATA CHANGES
  IsuzumaScoreModel _isuzumaScoreFromSnapshot(
      DocumentSnapshot documentSnapshot) {
    // GET THE DATA FROM THE SNAPSHOT
    final data = documentSnapshot.data() as Map<String, dynamic>;

    // CHECK IF THE FIELDS EXIST BEFORE ASSIGNING TO THE VARIABLE
    final id = documentSnapshot.id;
    final isuzumaID = data.containsKey('isuzumaID') ? data['isuzumaID'] : '';
    final takerID = data.containsKey('takerID') ? data['takerID'] : '';
    final marks = data.containsKey('marks') ? data['marks'] : 0;
    final totalMarks = data.containsKey('totalMarks') ? data['totalMarks'] : 0;
    final dateTaken = data.containsKey('dateTaken')
        ? (data['dateTaken'] as Timestamp).toDate()
        : DateTime.now();
    final questionsJson =
        data.containsKey('questions') ? data['questions'] as List<dynamic> : [];
    final questions = questionsJson
        .map<ScoreQuestionI>(
            (questionJson) => ScoreQuestionI.fromJson(questionJson))
        .toList();
    final amasomoJson =
        data.containsKey('amasomo') ? data['amasomo'] as List<dynamic> : [];
    final amasomo =
        amasomoJson.map<String>((amasomo) => amasomo.toString()).toList();
    final isuzumaTitle =
        data.containsKey('isuzumaTitle') ? data['isuzumaTitle'] : '';

    // RETURN A LIST OF AMASUZUMA SCORES FROM THE SNAPSHOT
    return IsuzumaScoreModel(
      // AMASUZUMA SCORES
      id: id,
      isuzumaID: isuzumaID,
      takerID: takerID,
      marks: marks,
      totalMarks: totalMarks,
      dateTaken: dateTaken,
      questions: questions,
      amasomo: amasomo,
      isuzumaTitle: isuzumaTitle,
    );
  }

// #############################################################################
// GET DATA
// #############################################################################
  // GET ALL AMASUZUMA SCORES
  Stream<List<IsuzumaScoreModel>> get amasuzumabumenyiScores {
    return isuzumaScoresCollection.snapshots().map(_amasuzumaScoreFromSnapshot);
  }

  // GET ONE isuzuma SCORE
  Stream<IsuzumaScoreModel> getIsuzumaScore(String id) {
    return isuzumaScoresCollection
        .doc(id)
        .snapshots()
        .map(_isuzumaScoreFromSnapshot);
  }

  // GET SCORES BY TAKER ID
  Stream<List<IsuzumaScoreModel>> getScoresByTakerID(String takerID) {
    return isuzumaScoresCollection
        .where('takerID', isEqualTo: takerID)
        .snapshots()
        .map(_amasuzumaScoreFromSnapshot);
  }

  // GET SCORE BY ITS ID
  Stream<IsuzumaScoreModel> getScoreByID(String id) {
    return isuzumaScoresCollection
        .doc(id)
        .snapshots()
        .map(_isuzumaScoreFromSnapshot);
  }

  // CREATE OR UPDATE THE SCORE - ADD OR UPDATE - ONE SCORE PER TAKER PER ISUZUMA
  Future<bool> createOrUpdateIsuzumaScore(IsuzumaScoreModel scoreModel) async {
    String isuzumaID = scoreModel.isuzumaID;
    String takerID = scoreModel.takerID;
    int marks = scoreModel.calculateMarks();
    int totalMarks = scoreModel.totalMarks;
    DateTime dateTaken = scoreModel.dateTaken;
    List<ScoreQuestionI> questions = scoreModel.questions;
    List<String>? amasomo = scoreModel.amasomo;

    // CREATE OR UPDATE THE SCORE
    try {
      await isuzumaScoresCollection.doc('${takerID}_$isuzumaID').set({
        'id': '${takerID}_$isuzumaID',
        'isuzumaID': isuzumaID,
        'takerID': takerID,
        'marks': marks,
        'totalMarks': totalMarks,
        'dateTaken': dateTaken,
        // QUESTIONS IN FIRESTORE ARE STORED AS A LIST OF MAPS WITH OPTIONS ALSO STORED AS A LIST OF MAPS
        // SO WE NEED TO CONVERT THE QUESTIONS LIST TO A LIST OF MAPS USING SERIALIZER AND DESERIALIZER
        'questions': questions.map((question) => question.toJson()).toList(),
        'amasomo': amasomo
      });
      return true;
    } catch (e) {
      print('Error creating or updating score');
      print(e.toString());
      return false;
    }
  }
}
// #############################################################################
// END OF FILE
// #############################################################################