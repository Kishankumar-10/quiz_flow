from fastapi import APIRouter, Query
from app.services.stackexchange import fetch_questions
from app.services.mcq_builder import build_mcq
from app.models.quiz import QuizQuestion  # IMPORTANT
from app.services.cache import get_cached, set_cache

router = APIRouter(prefix="/quiz", tags=["Quiz"])

@router.get("/")
def get_quiz(
    tag: str = Query(default="flutter"),
    limit: int = Query(default=5, ge=3, le=15),
):
    raw_questions = fetch_questions(tag=tag, limit=limit)

    questions = []

    for q in raw_questions:
        mcq = build_mcq(q, tag=tag)
        if not mcq:
            continue

        # HARD SANITIZATION (DO NOT SKIP)
        if not mcq["question"] or mcq.get("options") is None:
            continue
        # Allow Q&A fallback (single option) but enforce integrity for MCQ
        opts = [str(o).strip() for o in mcq["options"] if str(o).strip()]
        if mcq.get("type") == "mcq" and len(opts) != 4:
            continue

        questions.append(
            QuizQuestion(
                id=int(mcq["id"]),
                question=str(mcq["question"]),
                options=opts,
                correct_index=int(mcq["correct_index"]),
                type=mcq.get("type", "mcq"),
            )
        )

        if len(questions) == limit:
            break

    return {
        "tag": tag,
        "mode": "live",
        "count": len(questions),
        "questions": questions,
    }
