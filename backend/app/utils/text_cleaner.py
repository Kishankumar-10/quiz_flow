from bs4 import BeautifulSoup


def clean_text(html: str, max_length: int = 200) -> str:
    soup = BeautifulSoup(html, "html.parser")
    text = soup.get_text(separator=" ", strip=True)

    if len(text) > max_length:
        text = text[:max_length] + "..."

    return text
