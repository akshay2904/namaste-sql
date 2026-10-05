"""Scrape all coding problems from api.namastesql.com and save as JSON."""
import json
import time
import urllib.request
from urllib.error import URLError

API_BASE = "https://api.namastesql.com/api/v1/question_banks/listing/"
OUTPUT = "problems.json"

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
    "Accept": "application/json",
    "Referer": "https://www.namastesql.com/",
    "Origin": "https://www.namastesql.com",
}


def fetch_page(page: int) -> list[dict]:
    url = f"{API_BASE}?page={page}"
    req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req, timeout=20) as r:
        body = json.loads(r.read())
    return body["result"]["main_data"]["data"]


def extract(item: dict) -> dict:
    a = item["attributes"]
    level = a.get("level")
    category = a.get("category")
    return {
        "id": item["id"],
        "slug": a.get("slug"),
        "title": a.get("title"),
        "difficulty": level["name"] if isinstance(level, dict) else level,
        "category": category["name"] if isinstance(category, dict) else category,
        "companies": a.get("companies", []),
        "is_paid": a.get("is_paid"),
        "is_problem_solving": a.get("is_problem_solving"),
        "url": f"https://www.namastesql.com/coding-problems/{a.get('slug')}",
    }


def main():
    all_problems = []
    page = 1

    while True:
        print(f"Fetching page {page}...", end=" ", flush=True)
        try:
            items = fetch_page(page)
        except URLError as e:
            print(f"Error: {e}")
            break

        if not items:
            print("empty — done.")
            break

        problems = [extract(item) for item in items]
        all_problems.extend(problems)
        print(f"{len(items)} items  (total so far: {len(all_problems)})")

        if len(items) < 10:  # last partial page
            break

        page += 1
        time.sleep(0.3)  # be polite

    print(f"\nTotal problems scraped: {len(all_problems)}")

    with open(OUTPUT, "w", encoding="utf-8") as f:
        json.dump(all_problems, f, indent=2, ensure_ascii=False)
    print(f"Saved to {OUTPUT}")

    # Quick summary
    by_diff = {}
    for p in all_problems:
        raw = p["difficulty"]
        if isinstance(raw, dict):
            d = raw.get("name") or raw.get("label") or str(raw)
        else:
            d = raw or "Unknown"
        by_diff[d] = by_diff.get(d, 0) + 1
    print("\nBy difficulty:")
    for k, v in sorted(by_diff.items()):
        print(f"  {k}: {v}")

    free = sum(1 for p in all_problems if not p["is_paid"])
    print(f"\nFree: {free}  |  Paid: {len(all_problems) - free}")


if __name__ == "__main__":
    main()
