import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itsindire/models/course_progress.dart';

class CourseProgressService {
  // COLLECTIONS REFERENCE - FIRESTORE
  final CollectionReference progressCollection =
      FirebaseFirestore.instance.collection('progresses');

  CourseProgressService();

  // GET progresses FROM A SNAPSHOT USING THE PROGRESS MODEL - _progressesFromSnapshot
  // FUNCTION CALLED EVERY TIME THE progresses DATA CHANGES
  List<CourseProgressModel> _progressesFromSnapshot(
      QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = data.containsKey('id') ? data['id'] : '';
      final userId = data.containsKey('userId') ? data['userId'] : '';
      final courseId = data.containsKey('courseId') ? data['courseId'] : 0;
      final currentIngingo =
          data.containsKey('currentIngingo') ? data['currentIngingo'] : 0;
      final totalIngingos =
          data.containsKey('totalIngingos') ? data['totalIngingos'] : 0;
      return CourseProgressModel(
        id: id,
        userId: userId,
        courseId: courseId,
        currentIngingo: currentIngingo,
        totalIngingos: totalIngingos,
      );
    }).toList();
  }

  // GET ONE USER progress ON A COURSE FROM A SNAPSHOT USING THE PROGRESS MODEL - _progressFromSnapshot
  // FUNCTION CALLED EVERY TIME THE progresses DATA CHANGES
  CourseProgressModel _progressFromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    final id = data.containsKey('id') ? data['id'] : '';
    final userId = data.containsKey('userId') ? data['userId'] : '';
    final courseId = data.containsKey('courseId') ? data['courseId'] : 0;
    final currentIngingo =
        data.containsKey('currentIngingo') ? data['currentIngingo'] : 0;
    final totalIngingos =
        data.containsKey('totalIngingos') ? data['totalIngingos'] : 0;

    // RETURN A LIST OF progresses FROM THE SNAPSHOT
    return CourseProgressModel(
      id: id,
      userId: userId,
      courseId: courseId,
      currentIngingo: currentIngingo,
      totalIngingos: totalIngingos,
    );
  }

  // GET A LIST OF PROGRESSES OF USER ON finished and unfinished progress ON A COURSE STREAM
  Stream<List<CourseProgressModel?>>? getUserProgresses(String? uid) {
    if (uid == null || uid == '') return null;
    return progressCollection
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map(_progressesFromSnapshot);
  }

  // GET ONE USER progress ON A COURSE STREAM
  Stream<CourseProgressModel?>? getProgress(String? uid, int? courseId) {
    if (uid == null || uid == '') return null;
    if (courseId == null || courseId == 0) return null;
    return progressCollection
        .doc('${courseId}_$uid')
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return null;
      } else {
        return _progressFromSnapshot(snapshot);
      }
    });
  }

  // FINISHED PROGRESSES STREAM
  Stream<List<CourseProgressModel?>>? getFinishedProgresses(String? uid) {
    if (uid == null || uid == '') return null;

    final userProgresses = getUserProgresses(uid);

    return userProgresses!.map((progresses) {
      return progresses.where((progress) {
        return progress!.currentIngingo == progress.totalIngingos;
      }).toList();
    });
  }

  Stream<List<CourseProgressModel?>>? getUnfinishedProgresses(String? uid) {
    if (uid == null || uid == '') return null;

    final userProgresses = getUserProgresses(uid);

    return userProgresses!.map((progresses) {
      return progresses.where((progress) {
        return progress!.currentIngingo < progress.totalIngingos;
      }).toList();
    });
  }

  // THIS FUNCTION WILL UPDATE THE USER PROGRESS ON A COURSE IN THE DATABASE
  //WHEN THE USER START AND WHEN THE USER IS LEARNING A COURSE AND WHEN THE USER FINISHES A COURSE
  Future updateUserCourseProgress(
    String uid,
    int courseId,
    int currentIngingo,
    int totalIngingos,
  ) async {
    print('$uid $courseId $currentIngingo $totalIngingos');
    return await progressCollection.doc('${courseId}_$uid').set({
      'id': '${courseId}_$uid',
      'userId': uid,
      'courseId': courseId,
      'currentIngingo':
          currentIngingo > totalIngingos ? totalIngingos : currentIngingo,
      'totalIngingos': totalIngingos,
    });
  }
}
