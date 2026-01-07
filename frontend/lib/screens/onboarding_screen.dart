import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Focus Modes
  final List<Map<String, String>> focusModes = [
    {'label': 'Practice', 'value': 'practice'},
    {'label': 'Interview', 'value': 'interview'},
    {'label': 'Quick Test', 'value': 'quick'},
  ];

  String selectedFocusMode = 'practice';

  // Language options
  final List<Map<String, String>> languages = [
    {'label': 'Flutter', 'value': 'flutter'},
    {'label': 'Dart', 'value': 'dart'},
    {'label': 'Android', 'value': 'android'},
    {'label': 'Java', 'value': 'java'},
    {'label': 'Kotlin', 'value': 'kotlin'},
  ];

  // Default selected language
  String selectedLanguage = 'flutter';
  final TextEditingController _questionController = TextEditingController(
    text: '5',
  );

  int questionCount = 5;
  void _onQuestionCountChanged(String value) {
    if (value.isEmpty) {
      return;
    }

    final int parsed = int.tryParse(value) ?? 5;

    int clampedValue = parsed;
    if (parsed < 3) clampedValue = 3;
    if (parsed > 15) clampedValue = 15;

    if (clampedValue.toString() != value) {
      _questionController.text = clampedValue.toString();
      _questionController.selection = TextSelection.fromPosition(
        TextPosition(offset: _questionController.text.length),
      );
    }

    questionCount = clampedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QuizFlow')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            const Text(
              'Practice Setup',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            // Language Section
            const Text(
              'Select Language',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  languages.map((lang) {
                    final bool isSelected = selectedLanguage == lang['value'];

                    return ChoiceChip(
                      label: Text(lang['label']!),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedLanguage = lang['value']!;
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 32),

            const Text(
              'Focus Mode',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  focusModes.map((mode) {
                    final bool isSelected = selectedFocusMode == mode['value'];

                    return ChoiceChip(
                      label: Text(mode['label']!),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedFocusMode = mode['value']!;
                        });
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 32),

            // Question Count Section (still static)
            const Text(
              'Number of Questions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _questionController,
              keyboardType: TextInputType.number,
              onChanged: _onQuestionCountChanged,
              decoration: const InputDecoration(
                hintText: 'Enter between 3 and 15',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8),

            const Text('Min 3, Max 15', style: TextStyle(color: Colors.grey)),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => QuizScreen(
        language: selectedLanguage,
        questionCount: questionCount,
        focusMode: selectedFocusMode,
      ),
    ),
  );
},

                child: const Text('Start Practice'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
