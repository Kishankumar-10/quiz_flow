import random
from app.services.stackexchange import fetch_answers
from app.utils.text_cleaner import clean_text


def build_mcq(question):
    question_id = question["question_id"]
    question_title = question["title"]

    answers = fetch_answers(question_id)

    if not answers:
        return None

    correct_answer = None
    wrong_answers = []

    for ans in answers:
        text = clean_text(ans.get("body", ""))

        if not text:
            continue

        if ans.get("is_accepted") and not correct_answer:
            correct_answer = text
        else:
            wrong_answers.append(text)

    # Fallback: if no accepted answer, take top-voted answer
    if not correct_answer and wrong_answers:
        correct_answer = wrong_answers.pop(0)

    # Still not enough data
    if not correct_answer or len(wrong_answers) < 1:
        return None

    # Build options (max 4)
    options = [correct_answer] + wrong_answers[:3]

    # Shuffle options
    random.shuffle(options)

    correct_index = options.index(correct_answer)

    return {
        "id": question_id,
        "question": question_title,
        "options": options,
        "correct_index": correct_index,
    }
