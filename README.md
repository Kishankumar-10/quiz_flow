# QuizFlow

## 🎯 Project Overview
- Flutter-based quiz app with a FastAPI backend.
- Uses real StackOverflow data via the StackExchange API.
- Users select language, number of questions, and focus mode.
- Stable integration and a modern UI with splash, onboarding, quiz flow, and session summary.

## 🚀 Key Features
- Real questions sourced from StackOverflow.
- Multiple programming languages supported (Flutter, Dart, Java, Kotlin, Android).
- Clean Material 3 design with card-based layout and subtle animations.
- Consistent feedback across Practice, Interview, and Quick Test modes.
- Stable backend integration for reliable data fetching.

## 🧠 Learning & Quiz Modes
- Practice: Single-question flow with immediate feedback.
- Interview: Focused, single-selection interaction aligned with practice feedback.
- Quick Test: Short sessions with lightweight questions for rapid practice.

## 🛠 Tech Stack
- Frontend: Flutter (Dart, Material 3).
- Backend: FastAPI (Uvicorn), Requests, Pydantic, BeautifulSoup4.
- Data: StackExchange API (StackOverflow).

## 🔄 App Flow
1. Splash Screen
2. Onboarding
3. Practice Setup (language, mode, question count)
4. Quiz Flow
5. Session Summary

## ⚙️ Setup Instructions

### Backend
1. `cd backend`
2. Create and activate a virtual environment:
   - Windows: `python -m venv venv && venv\Scripts\activate`
   - macOS/Linux: `python3 -m venv venv && source venv/bin/activate`
3. Install dependencies: `pip install -r requirements.txt`
4. Run the server: `uvicorn app.main:app --reload`
5. API available at: `http://127.0.0.1:8000/`

### Frontend
1. `cd frontend`
2. Install: `flutter pub get`
3. Run: `flutter run`

## � Roadmap
- AI-generated MCQs (in progress): Generate plausible distractors from real questions while keeping the accepted answer as the single source of truth. Strict validation and caching planned.
- Expanded language support and filters.
- Lightweight analytics for study sessions.

## 📸 Screenshots

<p align="center">
  <img src="./screenshots/homeScreen04.png" alt="Home Screen" width="420" />
  <img src="./screenshots/onboardingScreen01.png" alt="Onboarding – Welcome" width="420" />
</p>
<p align="center">
  <img src="./screenshots/onboardingScreen02.png" alt="Onboarding – Features" width="420" />
  <img src="./screenshots/onboardingScreen03.png" alt="Onboarding – Get Started" width="420" />
</p>
<p align="center">
  <img src="./screenshots/quizScreen05.png" alt="Quiz Screen" width="420" />
</p>

## 📄 License
- TBD. A formal license will be added; until then, usage is restricted.

