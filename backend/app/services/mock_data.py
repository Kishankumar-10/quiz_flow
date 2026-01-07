def get_mock_questions(tag: str, limit: int):
    questions = []

    for i in range(limit):
        questions.append({
            "id": i + 1,
            "question": f"[{tag.upper()}] Sample Question {i + 1}",
            "options": [
                "Option A",
                "Option B",
                "Option C",
                "Option D",
            ],
            "correct_index": i % 4,
            "type": "mcq",
        })

    return questions
