// MODEL TO REPRESENT THE PROGRESS
class CourseProgressModel {
  // TITLE AND DESCRIPTION
  String id = '';
  String userId = '';
  int courseId = 0;
  int currentIngingo = 0;
  int totalIngingos = 0;

  CourseProgressModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.currentIngingo,
    required this.totalIngingos,
  });

// GET THE PROGRESS PERCENTAGE
  get progressPercentage => currentIngingo / totalIngingos;

  // TO STRING
  @override
  String toString() {
    return 'CourseProgressModel{id: $id, userId: $userId, courseId: $courseId, currentIngingo: $currentIngingo, totalIngingos: $totalIngingos}';
  }
}
