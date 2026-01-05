from fastapi import APIRouter, Query
from app.services.stackexchange import fetch_questions
from app.services.mcq_builder import build_mcq
from app.services.cache import get_cached, set_cache

router = APIRouter(prefix="/quiz", tags=["Quiz"])


@router.get("/")
def get_quiz(
    tag: str = Query(default="android"),
    limit: int = Query(default=10, le=20),
):
    try:
        cached = get_cached(tag)
        if cached:
            return {
                "tag": tag,
                "cached": True,
                "count": len(cached),
                "questions": cached,
            }

        raw_questions = fetch_questions(tag=tag, limit=limit)

        mcqs = []
        for q in raw_questions:
            mcq = build_mcq(q)
            if mcq:
                mcqs.append(mcq)

        if mcqs:
            set_cache(tag, mcqs)

        return {
            "tag": tag,
            "cached": False,
            "count": len(mcqs),
            "questions": mcqs,
        }

    except Exception as e:
        # THIS ensures FastAPI never returns 500
        return {
            "error": "QUIZ_GENERATION_FAILED",
            "message": str(e),
        }
