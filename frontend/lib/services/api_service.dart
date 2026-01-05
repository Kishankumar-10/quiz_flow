import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_question.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static final List<String> tags = [
    'android',
    'flutter',
    'dart',
    'kotlin',
    'java',
  ];

  static int _tagIndex = 0;

  static Future<List<QuizQuestion>> fetchQuiz() async {
    final tag = tags[_tagIndex % tags.length];
    _tagIndex++;

    final response = await http.get(
      Uri.parse('$baseUrl/quiz/?tag=$tag&limit=10'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load quiz');
    }

    final data = json.decode(response.body);
    final List questions = data['questions'];

    return questions.map((q) => QuizQuestion.fromJson(q)).toList();
  }
}
