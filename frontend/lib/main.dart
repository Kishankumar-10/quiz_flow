import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/quiz_question.dart';
import 'services/api_service.dart';

void main() {
  runApp(const QuizFlowApp());
}

class QuizFlowApp extends StatelessWidget {
  const QuizFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuizFlow',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // ===== QUIZ DATA =====
  late Future<List<QuizQuestion>> quizFuture;

  int currentIndex = 0;
  int? selectedOption;
  int score = 0;

  bool quizCompleted = false;
  bool answerSubmitted = false;

  // ===== STATS =====
  int totalQuizzes = 0;
  int bestScore = 0;

  @override
  void initState() {
    super.initState();
    quizFuture = loadQuiz();
    loadStats();
  }

  // ===== LOAD QUIZ =====
  Future<List<QuizQuestion>> loadQuiz() async {
    final questions = await ApiService.fetchQuiz();
    questions.shuffle();
    return questions;
  }

  // ===== LOAD SAVED STATS =====
  Future<void> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalQuizzes = prefs.getInt('totalQuizzes') ?? 0;
      bestScore = prefs.getInt('bestScore') ?? 0;
    });
  }

  // ===== SAVE STATS =====
  Future<void> saveStats() async {
    final prefs = await SharedPreferences.getInstance();

    totalQuizzes++;
    if (score > bestScore) {
      bestScore = score;
    }

    await prefs.setInt('totalQuizzes', totalQuizzes);
    await prefs.setInt('bestScore', bestScore);
  }

  // ===== OPTION SELECTION =====
  void onOptionSelected(int index) {
    if (answerSubmitted) return;

    setState(() {
      selectedOption = index;
      answerSubmitted = true;
    });
  }

  // ===== NEXT QUESTION / SUBMIT =====
  void goToNextQuestion(List<QuizQuestion> questions) {
    if (selectedOption == questions[currentIndex].correctIndex) {
      score++;
    }

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null;
        answerSubmitted = false;
      });
    } else {
      setState(() {
        quizCompleted = true;
      });
      saveStats();
    }
  }

  // ===== OPTION COLOR LOGIC =====
  Color getOptionColor(int index, QuizQuestion question) {
    if (!answerSubmitted) {
      return selectedOption == index
          ? Colors.blue.withOpacity(0.1)
          : Colors.transparent;
    }

    if (index == question.correctIndex) {
      return Colors.green.withOpacity(0.2);
    }

    if (selectedOption == index && index != question.correctIndex) {
      return Colors.red.withOpacity(0.2);
    }

    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QuizFlow')),
      body: FutureBuilder<List<QuizQuestion>>(
        future: quizFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<QuizQuestion> questions = snapshot.data!;

          if (questions.isEmpty) {
            return const Center(child: Text('No quiz available'));
          }

          // ===== RESULT SCREEN (STEP 5 – POLISHED) =====
          if (quizCompleted) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Quiz Completed 🎉',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Score: $score / ${questions.length}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text('Best Score: $bestScore'),
                      Text('Quizzes Played: $totalQuizzes'),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            currentIndex = 0;
                            selectedOption = null;
                            score = 0;
                            quizCompleted = false;
                            answerSubmitted = false;
                            quizFuture = loadQuiz();
                          });
                        },
                        child: const Text('Restart Quiz'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // ===== QUESTION SCREEN =====
          final question = questions[currentIndex];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${currentIndex + 1} of ${questions.length}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),

                // Question Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Options
                ...List.generate(question.options.length, (index) {
                  return GestureDetector(
                    onTap: () => onOptionSelected(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: getOptionColor(index, question),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        question.options[index],
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }),

                const Spacer(),

                // ===== NEXT BUTTON (STEP 4 – POLISHED) =====
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed:
                        selectedOption == null
                            ? null
                            : () => goToNextQuestion(questions),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
