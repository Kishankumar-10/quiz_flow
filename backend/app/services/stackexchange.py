import requests

STACK_EXCHANGE_API_KEY = "rl_TPBX3oErzauxLkrTi1H4DpAt9E"

QUESTIONS_API = "https://api.stackexchange.com/2.3/questions"
ANSWERS_API = "https://api.stackexchange.com/2.3/questions/{ids}/answers"


def fetch_questions(tag: str, limit: int = 5):
    try:
        params = {
            "order": "desc",
            "sort": "activity",
            "tagged": tag,
            "site": "stackoverflow",
            "pagesize": limit,
            "key": "rl_TPBX3oErzauxLkrTi1H4DpAt9",
        }

        response = requests.get(QUESTIONS_API, params=params, timeout=10)
        response.raise_for_status()

        data = response.json()

        # Stack Exchange returns errors INSIDE JSON
        if "items" not in data:
            print("STACK EXCHANGE ERROR:", data)
            return []

        return data["items"]

    except Exception as e:
        print("FETCH QUESTIONS FAILED:", e)
        return []


def fetch_answers(question_id: int):
    try:
        params = {
            "order": "desc",
            "sort": "votes",
            "site": "stackoverflow",
            "filter": "withbody",
            "key": "rl_TPBX3oErzauxLkrTi1H4DpAt9",
        }

        url = ANSWERS_API.format(ids=question_id)
        response = requests.get(url, params=params, timeout=10)
        response.raise_for_status()

        data = response.json()

        if "items" not in data:
            print("STACK EXCHANGE ANSWERS ERROR:", data)
            return []

        return data["items"]

    except Exception as e:
        print("FETCH ANSWERS FAILED:", e)
        return []
