from fastapi import FastAPI
from app.routes.quiz import router as quiz_router

app = FastAPI(title="QuizFlow Backend")

app.include_router(quiz_router)


@app.get("/")
def root():
    return {"message": "QuizFlow backend is running"}
