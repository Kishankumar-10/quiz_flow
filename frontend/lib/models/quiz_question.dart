class QuizQuestion {
  final int id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String type;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.type,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctIndex: json['correct_index'],
      type: json['type'],
    );
  }
}
