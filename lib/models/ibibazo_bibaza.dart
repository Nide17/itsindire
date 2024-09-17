class IbibazoBibazaModel {
  String? id;
  String? question;
  String? answer;

  IbibazoBibazaModel({
    this.id,
    this.question,
    this.answer,
  });

  // FROM JSON
  factory IbibazoBibazaModel.fromJson(Map<String, dynamic> json) {
    return IbibazoBibazaModel(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
    );
  }

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
    };
  }

  // TO STRING
  @override
  String toString() {
    return 'IbibazoBibazaModel{id: $id, question: $question, answer: $answer}';
  }
}
