// MODEL TO REPRESENT THE PROGRESS
class CourseProgressModel {
  // TITLE AND DESCRIPTION
  String id = '';
  String userId = '';
  String courseId = '';
  int currentIngingo = 0;
  int totalIngingos = 0;

  // CONSTRUCTOR
  CourseProgressModel(
      {required this.id,
      required this.userId,
      required this.courseId,
      required this.currentIngingo,
      required this.totalIngingos});

  // TO STRING
  @override
  String toString() {
    return 'CourseProgressModel{id: $id, userId: $userId, courseId: $courseId, currentIngingo: $currentIngingo, totalIngingos: $totalIngingos}';
  }
}
