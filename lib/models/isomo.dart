// MODEL TO REPRESENT THE ISOMO
class IsomoModel {
  // TITLE AND DESCRIPTION
  int id = 0;
  String title = '';
  String description = '';
  String introText = '';
  String conclusion = '';

  // CONSTRUCTOR
  IsomoModel({ required this.id, required this.title, required this.description, required this.introText, required this.conclusion });

  // TO STRING
  @override
  String toString() {
    return 'IsomoModel{id: $id, title: $title, description: $description, introText: $introText, conclusion: $conclusion}';
  }
}
