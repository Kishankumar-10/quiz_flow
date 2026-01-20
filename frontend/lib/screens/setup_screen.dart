import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  // Focus Modes
  final List<Map<String, dynamic>> focusModes = [
    {'label': 'Practice', 'value': 'practice', 'icon': Icons.school_outlined},
    {'label': 'Interview', 'value': 'interview', 'icon': Icons.work_outline},
    {'label': 'Quick Test', 'value': 'quick', 'icon': Icons.timer_outlined},
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
    if (value.isEmpty) return;

    final int? parsed = int.tryParse(value);
    if (parsed == null) return;

    questionCount = parsed;
  }

  void _applyQuestionCountValidation() {
    final rawText = _questionController.text.trim();
    final int? parsed = int.tryParse(rawText);

    int value = parsed ?? questionCount;
    if (value < 3) value = 3;
    if (value > 15) value = 15;

    if (_questionController.text != value.toString()) {
      _questionController.text = value.toString();
      _questionController.selection = TextSelection.fromPosition(
        TextPosition(offset: _questionController.text.length),
      );
    }

    questionCount = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Practice Setup',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLanguageCard(),
                    const SizedBox(height: 20),
                    _buildFocusModeCard(),
                    const SizedBox(height: 20),
                    _buildQuestionCountCard(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: child,
    );
  }

  Widget _buildLanguageCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Select Language'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: languages.map((lang) {
              final bool isSelected = selectedLanguage == lang['value'];
              return ChoiceChip(
                label: Text(
                  lang['label']!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF374151),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                selectedColor: const Color(0xFF2563EB),
                backgroundColor: Colors.grey.shade50,
                side: BorderSide(
                  color: isSelected ? Colors.transparent : Colors.grey.shade200,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                onSelected: (_) {
                  setState(() {
                    selectedLanguage = lang['value']!;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusModeCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Focus Mode'),
          Column(
            children: focusModes.map((mode) {
              final bool isSelected = selectedFocusMode == mode['value'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedFocusMode = mode['value']!;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFEFF6FF)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          mode['icon'],
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : Colors.grey.shade500,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          mode['label']!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF1D4ED8)
                                : const Color(0xFF374151),
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF2563EB),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCountCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Number of Questions'),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _questionController,
                    keyboardType: TextInputType.number,
                    onChanged: _onQuestionCountChanged,
                    onEditingComplete: _applyQuestionCountValidation,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '3-15',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Min 3, Max 15',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _applyQuestionCountValidation();
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Start Practice',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
