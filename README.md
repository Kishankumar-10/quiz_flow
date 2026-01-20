# QuizFlow 💡

Smart quiz app for developers, powered by real StackOverflow questions and a FastAPI backend.

---

## Project Overview

QuizFlow is a learning and interview-prep companion for developers. It fetches live questions from StackOverflow via the StackExchange API, converts them into multiple-choice questions (with AI assistance), and lets you practice in focused modes tailored to different goals: learning, interviewing, or quick self-checks.

The mobile app is built with Flutter, and the backend is implemented with FastAPI. A caching layer and safe fallbacks ensure the app remains usable even when external APIs are slow or unavailable.

---

## Key Features

- 🎯 **Developer-focused content**
  - Uses real StackOverflow questions via the StackExchange API.
  - Targets common developer stacks: Flutter, Dart, Android, Java, and Kotlin.

- 🧠 **Smart quiz modes**
  - **Practice Mode** – instant feedback on each question.
  - **Interview Mode** – delayed answer reveal and fewer options to simulate pressure.
  - **Quick Test Mode** – fast auto-advance for rapid assessment.

- ⚙️ **Configurable sessions**
  - Choose your **language/tech stack** (Flutter, Dart, Android, Java, Kotlin).
  - Select **number of questions** (minimum 3, maximum 15).
  - Quiz restart reuses the **previous configuration** for faster iteration.

- 📈 **Progress and feedback**
  - XP system, streaks, and best score tracking.
  - Session summary at the end of each quiz.

- 🔒 **Resilient backend**
  - FastAPI service with caching to reduce external API calls.
  - Safe fallback to mock data when StackExchange is unavailable or rate-limited.
  - API keys stored in `.env` and **never committed** to version control.

- ✅ **Thoughtful UX**
  - Onboarding flow is shown only on the first app launch.
  - Smooth transitions between modes and sessions.

---

## Screenshots

(Add your actual screenshots to the repository and keep this list in sync.)

- `screenshots/01_onboarding.png`
- `screenshots/02_home_practice_mode.png`
- `screenshots/03_interview_mode.png`
- `screenshots/04_quick_test_mode.png`
- `screenshots/05_session_summary.png`

---

## Tech Stack

- **Mobile (Frontend)**
  - Flutter
  - Dart

- **Backend**
  - FastAPI (Python)
  - StackExchange / StackOverflow API integration
  - Caching layer with fallback to mock data

- **Configuration & Tooling**
  - `.env` for secrets (StackExchange API key, etc.)
  - Git for version control

---

## Architecture Overview

- **Flutter app**
  - Handles onboarding, quiz configuration, quiz flow, and session summary.
  - Manages XP, streaks, and best score locally (and/or via backend, depending on configuration).
  - Communicates with the FastAPI backend for question retrieval.

- **FastAPI backend**
  - Exposes endpoints for fetching quiz questions based on:
    - Selected language/tech stack.
    - Requested number of questions.
  - Integrates with the StackExchange API to pull real StackOverflow questions.
  - Converts raw questions into MCQs (AI-assisted transformation).
  - Implements **caching** to avoid repeated external calls for similar queries.
  - Uses **safe fallback** to mock data when the external API fails or is unreachable.

- **Data flow**
  - User configures a quiz in the Flutter app.
  - App sends a request to the FastAPI backend with quiz parameters.
  - Backend fetches or retrieves cached questions, converts them to MCQs, and returns them.
  - App presents questions in the selected mode, tracks answers, and updates XP/streaks.
  - Session summary is generated at the end of the quiz.

- **Security & configuration**
  - Sensitive values (e.g., StackExchange API key) are stored in `.env`.
  - `.env` is excluded from version control; sample configuration can be documented separately.

---

## Environment Setup

### Prerequisites

- Flutter SDK installed and configured.
- Dart SDK (typically bundled with Flutter).
- Python 3.x installed.
- Git installed.

### Backend (.env)

In the backend directory (for the FastAPI service):

- Create a `.env` file.
- Add the required environment variables for:
  - StackExchange / StackOverflow API key.
  - Any other configuration used by the backend (e.g., site, caching options).
- Ensure `.env` is **not** committed (list it in `.gitignore`).

---

## Running the Project

The exact commands may differ slightly based on your directory layout. The steps below describe the typical flow.

### 1. Start the FastAPI backend

From the backend directory:

```bash
# Create and activate a virtual environment (example)
python -m venv .venv
# On Windows:
.venv\Scripts\activate
# On macOS/Linux:
source .venv/bin/activate

# Install dependencies (if using requirements.txt)
pip install -r requirements.txt

# Start the FastAPI app (adjust module name as needed)
uvicorn <module_name>:app --reload
```

- Replace `<module_name>` with the actual Python module that exposes the `FastAPI` app instance (e.g., `main`, `app.main`).

### 2. Run the Flutter app

From the Flutter app directory:

```bash
# Fetch dependencies
flutter pub get

# Run on a connected device or emulator
flutter run
```

- Select the desired device/emulator from your IDE or via `flutter devices`.

---

## Current Status

- Core quiz flow is implemented:
  - Question fetching from StackOverflow via StackExchange API.
  - AI-assisted conversion to MCQs.
  - Practice, Interview, and Quick Test modes.
  - XP, streaks, best score, and session summaries.
- Backend includes caching and a safe fallback to mock data for robustness.
- Onboarding, configuration persistence, and quiz restart behavior are implemented.
- Additional polish, testing, and documentation can be iteratively improved as the project evolves.

---

## License

If a `LICENSE` file is present in this repository, its terms apply to QuizFlow.

If no license has been added yet, please add an appropriate open-source or proprietary license before using this project in production or distributing it further.

# QuizFlow 💡

Smart quiz app for developers, powered by real StackOverflow questions and a FastAPI backend.

---

## Project Overview

QuizFlow is a learning and interview-prep companion for developers. It fetches live questions from StackOverflow via the StackExchange API, converts them into multiple-choice questions (with AI assistance), and lets you practice in focused modes tailored to different goals: learning, interviewing, or quick self-checks.

The mobile app is built with Flutter, and the backend is implemented with FastAPI. A caching layer and safe fallbacks ensure the app remains usable even when external APIs are slow or unavailable.

---

## Key Features

- 🎯 **Developer-focused content**
  - Uses real StackOverflow questions via the StackExchange API.
  - Targets common developer stacks: Flutter, Dart, Android, Java, and Kotlin.

- 🧠 **Smart quiz modes**
  - **Practice Mode** – instant feedback on each question.
  - **Interview Mode** – delayed answer reveal and fewer options to simulate pressure.
  - **Quick Test Mode** – fast auto-advance for rapid assessment.

- ⚙️ **Configurable sessions**
  - Choose your **language/tech stack** (Flutter, Dart, Android, Java, Kotlin).
  - Select **number of questions** (minimum 3, maximum 15).
  - Quiz restart reuses the **previous configuration** for faster iteration.

- 📈 **Progress and feedback**
  - XP system, streaks, and best score tracking.
  - Session summary at the end of each quiz.

- 🔒 **Resilient backend**
  - FastAPI service with caching to reduce external API calls.
  - Safe fallback to mock data when StackExchange is unavailable or rate-limited.
  - API keys stored in `.env` and **never committed** to version control.

- ✅ **Thoughtful UX**
  - Onboarding flow is shown only on the first app launch.
  - Smooth transitions between modes and sessions.

---

## Screenshots

(Add your actual screenshots to the repository and keep this list in sync.)

- `screenshots/01_onboarding.png`
- `screenshots/02_home_practice_mode.png`
- `screenshots/03_interview_mode.png`
- `screenshots/04_quick_test_mode.png`
- `screenshots/05_session_summary.png`

---

## Tech Stack

- **Mobile (Frontend)**
  - Flutter
  - Dart

- **Backend**
  - FastAPI (Python)
  - StackExchange / StackOverflow API integration
  - Caching layer with fallback to mock data

- **Configuration & Tooling**
  - `.env` for secrets (StackExchange API key, etc.)
  - Git for version control

---

## Architecture Overview

- **Flutter app**
  - Handles onboarding, quiz configuration, quiz flow, and session summary.
  - Manages XP, streaks, and best score locally (and/or via backend, depending on configuration).
  - Communicates with the FastAPI backend for question retrieval.

- **FastAPI backend**
  - Exposes endpoints for fetching quiz questions based on:
    - Selected language/tech stack.
    - Requested number of questions.
  - Integrates with the StackExchange API to pull real StackOverflow questions.
  - Converts raw questions into MCQs (AI-assisted transformation).
  - Implements **caching** to avoid repeated external calls for similar queries.
  - Uses **safe fallback** to mock data when the external API fails or is unreachable.

- **Data flow**
  - User configures a quiz in the Flutter app.
  - App sends a request to the FastAPI backend with quiz parameters.
  - Backend fetches or retrieves cached questions, converts them to MCQs, and returns them.
  - App presents questions in the selected mode, tracks answers, and updates XP/streaks.
  - Session summary is generated at the end of the quiz.

- **Security & configuration**
  - Sensitive values (e.g., StackExchange API key) are stored in `.env`.
  - `.env` is excluded from version control; sample configuration can be documented separately.

---

## Environment Setup

### Prerequisites

- Flutter SDK installed and configured.
- Dart SDK (typically bundled with Flutter).
- Python 3.x installed.
- Git installed.

### Backend (.env)

In the backend directory (for the FastAPI service):

- Create a `.env` file.
- Add the required environment variables for:
  - StackExchange / StackOverflow API key.
  - Any other configuration used by the backend (e.g., site, caching options).
- Ensure `.env` is **not** committed (list it in `.gitignore`).

---

## Running the Project

The exact commands may differ slightly based on your directory layout. The steps below describe the typical flow.

### 1. Start the FastAPI backend

From the backend directory:

```bash
# Create and activate a virtual environment (example)
python -m venv .venv
# On Windows:
.venv\Scripts\activate
# On macOS/Linux:
source .venv/bin/activate

# Install dependencies (if using requirements.txt)
pip install -r requirements.txt

# Start the FastAPI app (adjust module name as needed)
uvicorn <module_name>:app --reload
```

- Replace `<module_name>` with the actual Python module that exposes the `FastAPI` app instance (e.g., `main`, `app.main`).

### 2. Run the Flutter app

From the Flutter app directory:

```bash
# Fetch dependencies
flutter pub get

# Run on a connected device or emulator
flutter run
```

- Select the desired device/emulator from your IDE or via `flutter devices`.

---

## Current Status

- Core quiz flow is implemented:
  - Question fetching from StackOverflow via StackExchange API.
  - AI-assisted conversion to MCQs.
  - Practice, Interview, and Quick Test modes.
  - XP, streaks, best score, and session summaries.
- Backend includes caching and a safe fallback to mock data for robustness.
- Onboarding, configuration persistence, and quiz restart behavior are implemented.
- Additional polish, testing, and documentation can be iteratively improved as the project evolves.

---

## License

If a `LICENSE` file is present in this repository, its terms apply to QuizFlow.

If no license has been added yet, please add an appropriate open-source or proprietary license before using this project in production or distributing it further.  // ===== OPTION SELECTION =====
  void onOptionSelected(int index) {
    // Allow changing the selection; only navigation/scoring locks the answer.
    final bool shouldAutoAdvanceQuickTest = isQuickTestMode && !answerSubmitted;

    setState(() {
      selectedOption = index;
      answerSubmitted = true;
      reviewMode = false;
    });

    if (isQuickTestMode && shouldAutoAdvanceQuickTest) {
      Future.delayed(const Duration(milliseconds: 400), () {
        goToNextQuestion();
      });
    }
  }  // ===== OPTION SELECTION =====
  void onOptionSelected(int index) {
    // Allow changing the selection; only navigation/scoring locks the answer.
    final bool shouldAutoAdvanceQuickTest = isQuickTestMode && !answerSubmitted;

    setState(() {
      selectedOption = index;
      answerSubmitted = true;
      reviewMode = false;
    });

    if (isQuickTestMode && shouldAutoAdvanceQuickTest) {
      Future.delayed(const Duration(milliseconds: 400), () {
        goToNextQuestion();
      });
    }
  }// ===== OPTION SELECTION =====
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
}  // ===== LOAD QUIZ =====
  Future<List<QuizQuestion>> loadQuiz() async {
    final questions = await ApiService.fetchQuiz(
      tag: widget.language,
      limit: widget.questionCount,
    );

    // Quick Test uses the same question list so the requested count is preserved.
    return questions;
  }Future<List<QuizQuestion>> loadQuiz() async {
  final questions = await ApiService.fetchQuiz(
    tag: widget.language,
    limit: widget.questionCount,
  );

  if (isQuickTestMode) {
    return questions.where((q) => q.question.length <= 120).toList();
  }

  return questions;
}