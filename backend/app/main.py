from fastapi import FastAPI
from app.services.cache import clear_cache

from app.routes.quiz import router as quiz_router

app = FastAPI(title="QuizFlow Backend")
clear_cache()

app.include_router(quiz_router)


@app.get("/")
def root():
    return {"message": "QuizFlow backend is running"}
