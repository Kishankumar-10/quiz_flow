from fastapi import APIRouter, Query
from app.services.stackexchange import fetch_questions
from app.services.mock_data import get_mock_questions

router = APIRouter(prefix="/quiz", tags=["Quiz"])


@router.get("/")
def get_quiz(
    tag: str = Query(default="flutter"),
    limit: int = Query(default=5, ge=3, le=15),
):
    questions = get_mock_questions(tag, limit)

    return {
        "tag": tag,
        "mode": "mock",
        "count": len(questions),
        "questions": questions,
    }

