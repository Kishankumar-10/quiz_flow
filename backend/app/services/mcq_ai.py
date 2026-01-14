import re
from typing import List, Dict
from app.utils.text_cleaner import clean_text


def _sanitize(text: str) -> str:
    text = clean_text(text or "", max_length=160)
    return text.strip()


def _variant_replace(source: str) -> str:
    mapping = [
        (r"\bStatelessWidget\b", "StatefulWidget"),
        (r"\bStatefulWidget\b", "StatelessWidget"),
        (r"\bListView\b", "GridView"),
        (r"\bGridView\b", "ListView"),
        (r"\bFuture\b", "Stream"),
        (r"\bStream\b", "Future"),
        (r"\bconst\b", "final"),
        (r"\bfinal\b", "var"),
        (r"\basync\b", "sync"),
        (r"\bawait\b", "then"),
        (r"\bHTTP\b", "WebSocket"),
        (r"\bGET\b", "POST"),
        (r"\bPOST\b", "PUT"),
    ]
    result = source
    for pattern, repl in mapping:
        if re.search(pattern, result):
            result = re.sub(pattern, repl, result)
            break
    if result == source:
        # fallback slight paraphrase
        result = f"Try a different approach than: {source}"
    return result


def _make_distractors(title: str, answer: str) -> List[str]:
    base = _sanitize(answer)
    if not base:
        return []

    d1 = _variant_replace(base)
    d2 = "Use a global mutable state; avoid scoped state management."
    d3 = "Prefer blocking I/O to simplify flow; handle UI updates later."

    candidates = [d1, d2, d3]
    # sanitize and ensure non-empty unique
    clean = []
    seen = set()
    for c in candidates:
        s = _sanitize(c)
        if not s or s == base or s in seen:
            continue
        seen.add(s)
        clean.append(s)
    # pad if needed
    while len(clean) < 3:
        filler = f"Alternative not recommended for: {title}"
        s = _sanitize(filler)
        if s not in seen and s != base:
            seen.add(s)
            clean.append(s)
        else:
            break
    return clean[:3]


def generate_mcq_options(question_title: str, accepted_answer_html: str) -> Dict[str, object]:
    """
    Input: question title + accepted answer
    Output: strict JSON only:
      {
        "options": ["A", "B", "C", "D"],
        "correct_index": 0
      }
    """
    correct = _sanitize(accepted_answer_html)
    if not correct:
        return {"options": [], "correct_index": 0}

    distractors = _make_distractors(question_title, correct)
    if len(distractors) < 3:
        return {"options": [], "correct_index": 0}

    options = [correct] + distractors
    return {"options": options, "correct_index": 0}
