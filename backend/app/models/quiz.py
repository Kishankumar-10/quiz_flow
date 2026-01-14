from pydantic import BaseModel
from typing import List

class QuizQuestion(BaseModel):
    id: int
    question: str
    options: List[str]
    correct_index: int
    type: str
