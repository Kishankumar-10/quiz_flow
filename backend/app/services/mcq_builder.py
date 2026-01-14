import random
from app.services.stackexchange import fetch_answers
from app.services.mcq_ai import generate_mcq_options
from app.services.cache import get_cached, set_cache
from app.utils.text_cleaner import clean_text


def _validate(options, correct_index):
    if not isinstance(options, list) or len(options) != 4:
        return False
    if not isinstance(correct_index, int) or not (0 <= correct_index < 4):
        return False
    if any((not isinstance(o, str) or not o.strip()) for o in options):
        return False
    # ensure uniqueness to avoid multiple identical correct answers
    if len(set(options)) < 4:
        return False
    return True


def build_mcq(q, tag: str):
    title = q.get("title")
    qid = q.get("question_id")
    if not title or not qid:
        return None

    cache_key = f"quiz:{tag}:{qid}"
    cached = get_cached(cache_key)
    if cached:
        return cached

    answers = fetch_answers(qid) or []
    accepted = next((a for a in answers if a.get("is_accepted")), None)

    correct_html = (
        accepted.get("body") if accepted and accepted.get("body") else None
    )
    correct_text = clean_text(correct_html or "", max_length=200)

    if not correct_text:
        # No accepted answer; try top-voted as a fallback for Q&A mode
        top = answers[0] if answers else None
        top_text = clean_text((top or {}).get("body", "") or "", max_length=200)
        if not top_text:
            return None
        return {
            "id": qid,
            "question": title,
            "options": [top_text],
            "correct_index": 0,
            "type": "qa",
        }

    ai_out = generate_mcq_options(title, correct_html or correct_text)
    options = ai_out.get("options", [])
    correct_index = ai_out.get("correct_index", 0)

    # If AI failed, fallback to Q&A style (single correct)
    if not _validate(options, correct_index):
        result = {
            "id": qid,
            "question": title,
            "options": [correct_text],
            "correct_index": 0,
            "type": "qa",
        }
        set_cache(cache_key, result)
        return result

    # Shuffle options while tracking correct index
    pre_options = options[:]
    correct_value = pre_options[correct_index]
    random.shuffle(pre_options)
    new_correct_index = pre_options.index(correct_value)

    result = {
        "id": qid,
        "question": title,
        "options": pre_options,
        "correct_index": new_correct_index,
        "type": "mcq",
    }
    set_cache(cache_key, result)
    return result

