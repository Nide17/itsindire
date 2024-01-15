// MODEL TO REPRESENT THE ISOMO
class IsomoModel {
  int id = 0;
  String title = '';
  String description = '';
  String introText = '';
  String conclusion = '';
  int? duration = 0;

  IsomoModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.introText,
      required this.conclusion,
      this.duration});

  @override
  String toString() {
    return 'IsomoModel{id: $id, title: $title, description: $description, introText: $introText, conclusion: $conclusion, duration: $duration}';
  }
}
