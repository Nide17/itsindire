import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tegura/models/course_progress.dart';

class CourseProgressService {
  // COLLECTIONS REFERENCE - FIRESTORE
  final CollectionReference progressCollection =
      FirebaseFirestore.instance.collection('progresses');

  // CONSTRUCTOR
  CourseProgressService();

// #############################################################################
// MODELING DATA
// #############################################################################
  // GET progresses FROM A SNAPSHOT USING THE PROGRESS MODEL - _progressesFromSnapshot
  // FUNCTION CALLED EVERY TIME THE progresses DATA CHANGES
  List<CourseProgressModel> _progressesFromSnapshot(
      QuerySnapshot querySnapshot) {
    // GET THE DATA FROM THE SNAPSHOT
    return querySnapshot.docs.map((doc) {
      // GET THE DATA FROM THE SNAPSHOT
      final data = doc.data() as Map<String, dynamic>;

      // CHECK IF THE FIELDS EXISTS BEFORE ASSIGNING TO THE VARIABLE
      final id = data.containsKey('id') ? data['id'] : '';
      final userId = data.containsKey('userId') ? data['userId'] : '';
      final courseId = data.containsKey('courseId') ? data['courseId'] : 0;
      final totalIngingos =
          data.containsKey('totalIngingos') ? data['totalIngingos'] : 0;
      final currentIngingo =
          data.containsKey('currentIngingo') ? data['currentIngingo'] : 0;

      // RETURN A LIST OF progresses FROM THE SNAPSHOT
      return CourseProgressModel(
        // PROGRESSES DATA
        id: id,
        userId: userId,
        courseId: courseId,
        totalIngingos: totalIngingos,
        currentIngingo: currentIngingo,
      );
    }).toList();
  }

  // GET ONE USER progress ON A COURSE FROM A SNAPSHOT USING THE PROGRESS MODEL - _progressFromSnapshot
  // FUNCTION CALLED EVERY TIME THE progresses DATA CHANGES
  CourseProgressModel _progressFromSnapshot(DocumentSnapshot documentSnapshot) {
    // GET THE DATA FROM THE SNAPSHOT
    final data = documentSnapshot.data() as Map<String, dynamic>;

    // CHECK IF THE FIELDS EXIST BEFORE ASSIGNING TO THE VARIABLE
    final id = data.containsKey('id') ? data['id'] : '';
    final userId = data.containsKey('userId') ? data['userId'] : '';
    final courseId = data.containsKey('courseId') ? data['courseId'] : 0;
    final totalIngingos =
        data.containsKey('totalIngingos') ? data['totalIngingos'] : 0;
    final currentIngingo =
        data.containsKey('currentIngingo') ? data['currentIngingo'] : 0;

    // RETURN A LIST OF progresses FROM THE SNAPSHOT
    return CourseProgressModel(
      // PROGRESSES DATA
      id: id,
      userId: userId,
      courseId: courseId,
      totalIngingos: totalIngingos,
      currentIngingo: currentIngingo,
    );
  }

// #############################################################################
// FUNCTIONS FOR INTERACTING WITH THE DATABASE
// #############################################################################
  // // GET progresses STREAM
  // Stream<List<CourseProgressModel?>>? getAllProgresses(String? uid) {
  //   // CHECK IF CURRENT USER UID IS NULL, IF IT IS, RETURN NULL
  //   if (uid == null) return null;

  //   // GET ALL progresses FROM FIRESTORE AS A STREAM OF DOCUMENT SNAPSHOT
  //   return progressCollection.snapshots().map(_progressesFromSnapshot);
  // }

  // GET ONE USER progress ON A COURSE STREAM
  Stream<CourseProgressModel?>? getProgress(String? uid, int? courseId) {
    // CHECK IF CURRENT USER UID IS NULL, IF IT IS, RETURN NULL
    if (uid == null || uid == '') return null;

    // CHECK IF CURRENT COURSE ID IS NULL, IF IT IS, RETURN NULL
    if (courseId == null || courseId == 0) return null;

    // GET ONE USER progress ON A COURSE FROM FIRESTORE AS A STREAM OF DOCUMENT SNAPSHOT
    return progressCollection
        .doc('${courseId}_$uid')
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return null; // Return null if the document doesn't exist
      } else {
        return _progressFromSnapshot(snapshot);
      }
    });
  }

  // THIS FUNCTION WILL UPDATE THE USER PROGRESS ON A COURSE IN THE DATABASE
  //WHEN THE USER START AND WHEN THE USER IS LEARNING A COURSE AND WHEN THE USER FINISHES A COURSE
  Future updateUserCourseProgress(
    String uid,
    int courseId,
    int totalIngingos,
    int currentIngingo,
  ) async {
    // RETURN THE USER DATA - IF THE DOC DOESN'T EXIST,
    //IT WILL BE CREATED BY FIRESTORE

    print('TOTAL INGINGOS: $totalIngingos');
    return await progressCollection.doc('${courseId}_$uid').set({
      // USER PROGRESS DATA
      'id': '${courseId}_$uid',
      'userId': uid,
      'courseId': courseId,
      'totalIngingos': totalIngingos,
      'currentIngingo': currentIngingo,
    });
  }
}
