import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quiz_question.dart';
import '../services/api_service.dart';

class QuizScreen extends StatefulWidget {
  final String language;
  final int questionCount;
  final String focusMode;

  const QuizScreen({
    super.key,
    required this.language,
    required this.questionCount,
    required this.focusMode,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // ===== QUIZ DATA =====
  late Future<List<QuizQuestion>> quizFuture;
  late List<QuizQuestion> _currentQuestions;

  int currentIndex = 0;
  int? selectedOption;
  int score = 0;

  bool quizCompleted = false;
  bool answerSubmitted = false;
  bool reviewMode = false;

  // ===== MODES =====
  bool get isPracticeMode => widget.focusMode == 'practice';
  bool get isInterviewMode => widget.focusMode == 'interview';
  bool get isQuickTestMode => widget.focusMode == 'quick';

  // ===== REWARDS =====
  int totalXp = 0;
  int currentStreak = 0;

  @override
  void initState() {
    super.initState();
    quizFuture = loadQuiz();
    loadRewards();
  }

  // ===== LOAD QUIZ =====
  Future<List<QuizQuestion>> loadQuiz() async {
    final questions = await ApiService.fetchQuiz(
      tag: widget.language,
      limit: widget.questionCount,
    );

    if (isQuickTestMode) {
      return questions.where((q) => q.question.length <= 120).toList();
    }

    return questions;
  }

  // ===== REWARDS =====
  Future<void> loadRewards() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalXp = prefs.getInt('totalXp') ?? 0;
      currentStreak = prefs.getInt('currentStreak') ?? 0;
    });
  }

  Future<void> saveRewards() async {
    final prefs = await SharedPreferences.getInstance();

    totalXp += score * 10;
    currentStreak += 1;

    await prefs.setInt('totalXp', totalXp);
    await prefs.setInt('currentStreak', currentStreak);
  }

  // ===== OPTION SELECTION =====
  void onOptionSelected(int index) {
    if (answerSubmitted) return;

    setState(() {
      selectedOption = index;
      answerSubmitted = true;
      reviewMode = false;
    });

    if (isQuickTestMode) {
      Future.delayed(const Duration(milliseconds: 400), () {
        goToNextQuestion();
      });
    }
  }

  // ===== NEXT QUESTION =====
  void goToNextQuestion() {
    final question = _currentQuestions[currentIndex];
    final correctAnswer = question.options[question.correctIndex];

    if (selectedOption != null &&
        _optionsToShow(question)[selectedOption!] == correctAnswer) {
      score++;
    }

    if (currentIndex < _currentQuestions.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null;
        answerSubmitted = false;
        reviewMode = false;
      });
    } else {
      setState(() {
        quizCompleted = true;
      });
      saveRewards();
    }
  }

  // ===== OPTIONS LOGIC =====
  List<String> _optionsToShow(QuizQuestion question) {
    return question.options;
  }

  // ===== OPTION COLOR =====
  Color getOptionColor(
    int index,
    QuizQuestion question,
    List<String> optionsToShow,
  ) {
    if (!answerSubmitted) {
      return selectedOption == index
          ? Colors.blue.withOpacity(0.1)
          : Colors.transparent;
    }

    final correctAnswer = question.options[question.correctIndex];

    if (optionsToShow[index] == correctAnswer) {
      return Colors.green.withOpacity(0.2);
    }
    if (selectedOption == index && optionsToShow[index] != correctAnswer) {
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

          _currentQuestions = snapshot.data!;

          if (_currentQuestions.isEmpty) {
            return const Center(child: Text('No quiz available'));
          }

          // ===== SESSION SUMMARY =====
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
                        'Session Summary',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text('Mode: ${widget.focusMode}'),
                      Text('Questions: ${_currentQuestions.length}'),
                      Text('Correct: $score'),
                      Text(
                        'Accuracy: ${(score / _currentQuestions.length * 100).toStringAsFixed(0)}%',
                      ),

                      const SizedBox(height: 8),
                      Text('XP Earned: ${score * 10}'),
                      Text('Total XP: $totalXp'),
                      Text('Streak: $currentStreak 🔥'),

                      if (isQuickTestMode) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Answer Review',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: _currentQuestions.length,
                            itemBuilder: (context, index) {
                              final q = _currentQuestions[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  '${index + 1}. ${q.question}\n'
                                  'Correct: ${q.options[q.correctIndex]}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentIndex = 0;
                            selectedOption = null;
                            score = 0;
                            quizCompleted = false;
                            answerSubmitted = false;
                            reviewMode = false;
                            quizFuture = loadQuiz();
                          });
                        },
                        child: const Text('Play Again'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // ===== QUESTION SCREEN =====
          final question = _currentQuestions[currentIndex];
          final optionsToShow = _optionsToShow(question);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${currentIndex + 1} of ${_currentQuestions.length}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ...List.generate(optionsToShow.length, (index) {
                  return GestureDetector(
                    onTap: () => onOptionSelected(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: getOptionColor(index, question, optionsToShow),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        optionsToShow[index],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        selectedOption == null
                            ? null
                            : () {
                              goToNextQuestion();
                            },
                    child: const Text('Next'),
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
