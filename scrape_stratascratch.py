"""
Scrape StrataScratch coding problems (Medium + Hard, SQL) and save as .sql files.

Steps:
  1. Fetch all problem listings via GraphQL (fast, paginated)
  2. Scrape full question text from each detail page via Playwright (parallel)
  3. Write one .sql file per problem
"""
import json
import os
import re
import time
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed
from playwright.sync_api import sync_playwright, Browser

OUT_DIR = os.path.join(os.path.dirname(__file__), "stratascratch")
GRAPHQL  = "https://api.stratascratch.com/graphql/"
BASE_URL = "https://platform.stratascratch.com"

DIFFICULTY = {1: "Easy", 2: "Medium", 3: "Hard"}

GQL_HEADERS = {
    "Content-Type": "application/json",
    "Origin": BASE_URL,
    "Referer": BASE_URL + "/",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
}

LISTING_QUERY = """
query CodingQuestions($first: Int!, $offset: Int!, $codeType: Int!,
  $jobPositions: [Int], $difficulties: [Int]) {
  allEducationalQuestions(
    first: $first offset: $offset codeType: $codeType
    jobPositions: $jobPositions difficulties: $difficulties
    curatedFilter: 0 status: [] topics: [] companies: [] industries: []
  ) {
    totalCount
    edges {
      node {
        id
        url
        difficulty
        isFreemium
        questionShort
        companies { id name }
        tables(codeType: $codeType)
      }
    }
  }
}
"""


# ── 1. Fetch listing via GraphQL ─────────────────────────────────────────────

def gql_post(query: str, variables: dict) -> dict:
    payload = json.dumps({"query": query, "variables": variables}).encode()
    req = urllib.request.Request(GRAPHQL, data=payload, headers=GQL_HEADERS, method="POST")
    with urllib.request.urlopen(req, timeout=20) as r:
        return json.loads(r.read())


def fetch_listing() -> list[dict]:
    problems, offset = [], 0
    first = 50
    variables = {
        "codeType": 1,
        "jobPositions": [1, 2, 3, 4, 5, 10],
        "difficulties": [2, 3],
        "first": first,
        "offset": offset,
    }
    while True:
        variables["offset"] = offset
        resp = gql_post(LISTING_QUERY, variables)
        data = resp["data"]["allEducationalQuestions"]
        edges = data["edges"]
        if not edges:
            break
        for e in edges:
            n = e["node"]
            problems.append({
                "id": n["id"],
                "slug": n["url"].strip("/").split("/")[-1],
                "url": BASE_URL + n["url"],
                "title": n["questionShort"],
                "difficulty": DIFFICULTY.get(n["difficulty"], str(n["difficulty"])),
                "is_paid": not n["isFreemium"],
                "companies": [c["name"] for c in (n["companies"] or [])],
                "tables": n.get("tables") or [],
            })
        total = data["totalCount"]
        print(f"  offset {offset}: got {len(edges)} (total {total})")
        offset += first
        if offset >= total:
            break
        time.sleep(0.3)
    return problems


# ── 2. Scrape question text from detail pages ────────────────────────────────

def scrape_question_text(page, url: str) -> str:
    """Navigate to a detail page and extract the question description."""
    try:
        page.goto(url, wait_until="domcontentloaded", timeout=30000)
        page.wait_for_selector(".QuestionMetadata__question", timeout=10000)
        el = page.query_selector(".QuestionMetadata__question")
        return el.inner_text().strip() if el else ""
    except Exception as e:
        print(f"    WARN: {url} -> {e}")
        return ""


def scrape_all_texts(problems: list[dict], workers: int = 4) -> dict[str, str]:
    """Use N parallel Playwright pages to scrape question texts."""
    texts: dict[str, str] = {}
    total = len(problems)

    def worker_batch(batch: list[dict]) -> list[tuple[str, str]]:
        results = []
        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()
            page.set_extra_http_headers({
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
            })
            for prob in batch:
                text = scrape_question_text(page, prob["url"])
                results.append((prob["id"], text))
            browser.close()
        return results

    # Split into N batches
    batches = [problems[i::workers] for i in range(workers)]

    done = 0
    with ThreadPoolExecutor(max_workers=workers) as ex:
        futures = {ex.submit(worker_batch, b): b for b in batches}
        for fut in as_completed(futures):
            for pid, text in fut.result():
                texts[pid] = text
                done += 1
                print(f"  [{done}/{total}] scraped id={pid}")

    return texts


# ── 3. Build .sql file ───────────────────────────────────────────────────────

def safe_filename(title: str) -> str:
    name = re.sub(r'[\\/:*?"<>|\r\n\t]', "", title).strip(". ")
    return name[:120] + ".sql"


def build_sql(prob: dict, question_text: str) -> str:
    companies = ", ".join(prob["companies"]) or "N/A"
    access    = "Premium" if prob["is_paid"] else "Free"

    lines = []
    lines.append(f"-- {'=' * 70}")
    lines.append(f"-- {prob['title']}")
    lines.append(f"-- {'=' * 70}")
    lines.append(f"-- Difficulty : {prob['difficulty']}")
    lines.append(f"-- Companies  : {companies}")
    lines.append(f"-- Access     : {access}")
    lines.append(f"-- ID         : {prob['id']}")
    lines.append(f"-- URL        : {prob['url']}")
    lines.append(f"-- {'=' * 70}")
    lines.append("")

    if question_text:
        lines.append("/*")
        lines.append(question_text)
        lines.append("*/")
    else:
        lines.append("/* Question text unavailable — visit the URL above. */")

    # Table schemas
    tables = prob.get("tables") or []
    if tables:
        lines.append("")
        lines.append("-- Tables:")
        for tbl in tables:
            if isinstance(tbl, dict):
                cols = ", ".join(f"{c['name']} {c['type']}" for c in tbl.get("columns", []))
                lines.append(f"--   {tbl['name']}({cols})")

    lines.append("")
    lines.append("")
    lines.append("-- Write your SQL solution below:")
    lines.append("")
    return "\n".join(lines)


# ── Main ─────────────────────────────────────────────────────────────────────

def main():
    os.makedirs(OUT_DIR, exist_ok=True)

    print("Step 1: Fetching listing from GraphQL...")
    problems = fetch_listing()
    print(f"  Total problems: {len(problems)}\n")

    # Save listing for reference
    with open(os.path.join(OUT_DIR, "_problems.json"), "w", encoding="utf-8") as f:
        json.dump(problems, f, indent=2)

    print("Step 2: Scraping question texts (4 parallel browsers)...")
    texts = scrape_all_texts(problems, workers=4)
    print()

    print("Step 3: Writing .sql files...")
    for prob in problems:
        text = texts.get(prob["id"], "")
        content = build_sql(prob, text)
        fname = safe_filename(prob["title"])
        with open(os.path.join(OUT_DIR, fname), "w", encoding="utf-8") as f:
            f.write(content)

    print(f"\nDone! {len(problems)} files saved to: {OUT_DIR}")

    by_diff = {}
    for p in problems:
        by_diff[p["difficulty"]] = by_diff.get(p["difficulty"], 0) + 1
    print("\nBy difficulty:")
    for k, v in sorted(by_diff.items()):
        print(f"  {k}: {v}")
    free = sum(1 for p in problems if not p["is_paid"])
    print(f"\nFree: {free}  |  Paid: {len(problems) - free}")


if __name__ == "__main__":
    main()
