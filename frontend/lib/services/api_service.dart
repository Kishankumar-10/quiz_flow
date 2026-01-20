import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_question.dart';

class ApiService {
  static const String baseUrl = 'https://quiz-flow-vxs8.onrender.com';

  static Future<List<QuizQuestion>> fetchQuiz({
    required String tag,
    required int limit,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/quiz/?tag=$tag&limit=$limit'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load quiz');
    }

    final data = json.decode(response.body);
    final List questions = data['questions'];

    return questions.map((q) => QuizQuestion.fromJson(q)).toList();
  }
}
