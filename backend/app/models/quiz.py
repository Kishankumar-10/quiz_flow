from pydantic import BaseModel
from typing import List


class QuizQuestion(BaseModel):
    id: str
    question: str
    options: List[str]
    correct_index: int
