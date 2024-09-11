import requests
import uvicorn
from bs4 import BeautifulSoup
from fastapi import FastAPI

app = FastAPI()


@app.get("/check")
async def check():
    return {"status": "ok"}


@app.get("/articles")
def search_scholar(query):
    url = f"https://scholar.google.com/scholar?q={query}"
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, headers=headers)

    soup = BeautifulSoup(response.content, "html.parser")

    articles = soup.find_all("div", class_="gs_ri")

    for article in articles:
        title = article.find("h3", class_="gs_rt").text
        link = article.find("a")
        href = link.get("href")
        return f"Title: {title}, " f"Link: {href}\n"


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8080)
