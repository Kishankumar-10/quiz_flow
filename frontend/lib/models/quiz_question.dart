class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: (json['question'] ?? '').toString(),
      options:
          (json['options'] as List? ?? [])
              .map((e) => e?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList(),
      correctIndex: json['correct_index'] ?? 0,
    );
  }
}
